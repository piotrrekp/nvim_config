local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
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
		text_node({"#ifndef "}), function_node(guard_name, {}),
		text_node({"", "#define "}), function_node(guard_name, {}),
		text_node({"", "", ""}), insert_node(0),
		text_node({"", "", "#endif // "}), function_node(guard_name, {})
	}),
})


ls.add_snippets("cpp", {
	snippet("main", {
		text_node({"int main(int argc, char **argv) {"}),
		text_node({"", "\t"}), insert_node(0),
		text_node({"", "\treturn 0;"}),
		text_node({"", "}"})
	}),
})


ls.add_snippets("cpp", {
	snippet("ptest", fmt([[
		class {} : public {}, public ::testing::TestWithParam<{}> {{
		}};

		INSTANTIATE_TEST_SUITE_P(, {}, ::testing::Values({{
			 {}
		    }}));

		TEST_P({}, {}) {{
		    {}
		}}
    ]], {
        i(1, "TestFixtureName"),    -- Test fixture class name
        i(2, "BaseClass"),	    -- Base class if needed
        i(3, "ParamType"),          -- Parameter type
        rep(1),                     -- Test fixture class name again in TEST_P
        i(4, "param1, param2"),     -- Parameter values
        rep(1),                     -- Test fixture class name again in INSTANTIATE_TEST_SUITE_P
        i(5, "TestName"),           -- Test name
        i(6, "// Test body..."),    -- Test body
	}))
    })
