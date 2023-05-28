// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

let plugin = require("tailwindcss/plugin");

module.exports = {
	content: [
		"./js/**/*.js",
		"../lib/*_web.ex",
		"../lib/*_web/**/*.*ex",
		"../lib/*_web/**/*.ex",
		"../lib/*_web.heex",
		"../lib/*_web/**/*.*heex",
		"../lib/*_web/**/*.heex",
	],
	darkMode: "class",
	theme: {
		extend: {
			colors: {
				text: "#091009",
				background: "#fcfdfc",
				primary_button: "#1e5e9e",
				secondary_button: "#d4f2e5",
				accent: "#2c9bba",
			}
		},
	},
	plugins: [
		require("@tailwindcss/forms"),
		plugin(({ addVariant }) =>
			addVariant("phx-no-feedback", ["&.phx-no-feedback", ".phx-no-feedback &"])
		),
		plugin(({ addVariant }) =>
			addVariant("phx-click-loading", [
				"&.phx-click-loading",
				".phx-click-loading &",
			])
		),
		plugin(({ addVariant }) =>
			addVariant("phx-submit-loading", [
				"&.phx-submit-loading",
				".phx-submit-loading &",
			])
		),
		plugin(({ addVariant }) =>
			addVariant("phx-change-loading", [
				"&.phx-change-loading",
				".phx-change-loading &",
			])
		),
	],
};
