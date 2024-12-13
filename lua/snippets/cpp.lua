local ls = require("luasnip")
local snippet = ls.snippet
local text_node = ls.text_node
local insert_node = ls.insert_node
local function_node = ls.function_node

local function guard_name(_, snip)
	local filename = snip.env.TM_FILENAME or "header"
	return string.upper( "_" .. filename:gsub("%.", "_") .. "_")
end

ls.add_snippets("cpp", {
	snippet("guard", {
		text_node({"#ifnded "}), function_node(guard_name, {}),
		text_node({"", "#define "}), function_node(guard_name, {}),
		text_node({"", "", ""}), insert_node(0),
		text_node({"", "", "#endif // "}), function_node(guard_name, {})
	}),
})
