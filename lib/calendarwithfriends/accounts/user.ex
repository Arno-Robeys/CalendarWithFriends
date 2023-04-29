defmodule Calendarwithfriends.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias Calendarwithfriends.Accounts.User
  alias Calendarwithfriends.Events.Event
  alias Calendarwithfriends.Interests.Interest
  alias Calendarwithfriends.Friendships.Friendship
  alias Calendarwithfriends.FriendRequests.FriendRequest

  # @primary_key {:id,:binary_id,autogenerate: true}
  # @foreign_key_type :binary_id
  schema "users" do
    field(:full_name, :string)
    field(:email, :string)
    field(:password, :string, virtual: true, redact: true)
    field(:hashed_password, :string, redact: true)
    field(:confirmed_at, :naive_datetime)

    many_to_many(
      :friendships,
      User,
      join_through: Friendship,
      join_keys: [user_id: :id, friend_id: :id]
    )

    many_to_many(
      :reverse_friendships,
      User,
      join_through: Friendship,
      join_keys: [friend_id: :id, user_id: :id]
    )

    many_to_many(
      :friend_requests,
      User,
      join_through: FriendRequest,
      join_keys: [user_id: :id, pending_friend_id: :id]
    )

    many_to_many(
      :reverse_friend_requests,
      User,
      join_through: FriendRequest,
      join_keys: [pending_friend_id: :id, user_id: :id]
    )

    has_many(:events, Event)
    has_many(:interests, Interest)

    timestamps()
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:full_name, :email, :password])
    |> validate_email()
    |> validate_password(opts)
    |> validate_full_name()
  end

  defp validate_full_name(changeset) do
    changeset
    |> validate_required([:full_name])
    |> validate_length(:full_name, max: 160)
    |> validate_length(:full_name, min: 2)
    |> validate_format(:full_name, ~r/^[a-zA-Z\s]+$/,
      message: "must only contain letters and spaces"
    )
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Calendarwithfriends.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 72)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      |> put_change(:hashed_password, Pbkdf2.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  A user search.
  """
  def search(query, search_term) do
    wildcard_search = "%#{search_term}%"

    from(user in query,
      where: ilike(user.full_name, ^wildcard_search),
      or_where: ilike(user.email, ^wildcard_search)
    )
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A user changeset for changing the full name.

  It requires the full_name to change otherwise an error is added.
  """
  def full_name_changeset(user, attrs) do
    user
    |> cast(attrs, [:full_name])
    |> validate_full_name()
    |> case do
      %{changes: %{full_name: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :full_name, "did not change")
    end
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Pbkdf2.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(
        %Calendarwithfriends.Accounts.User{hashed_password: hashed_password},
        password
      )
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Pbkdf2.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Pbkdf2.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end
end
