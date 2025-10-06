return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")

      local cpplint = {
        method = null_ls.methods.DIAGNOSTICS,
        filetypes = { "cpp", "c", "h", "hh" },
        generator = null_ls.generator({
          command = vim.fn.expand("~/bin/cpplint.py"),
          args = {
            "--extensions=cpp,cc,c,h,hh",
            "--linelength=999",
            "--filter=" ..
              "-legal/copyright," ..
              "-build/include," ..
              "-build/header_guard," ..
              "-whitespace/tab," ..
              "-whitespace/comments," ..
              "-whitespace/indent," ..
              "-readability/casting",
            "$FILENAME",
          },
          format = "line",
          to_stdin = false,
          from_stderr = true,
          on_output = function(line)
            local _, row, msg, level = line:match("([^:]+):(%d+):%s+(.-)%s+%[.-%]%s+%[(%d+)%]")
            if row and msg then
              return {
                row = tonumber(row),
                col = 1,
                message = msg,
                severity = tonumber(level) >= 4 and 1 or 2,
                source = "cpplint",
              }
            end
          end,
        }),
      }

      null_ls.setup({
        sources = { cpplint },
      })
      vim.api.nvim_create_user_command("Cpplint", function()
        vim.cmd("Telescope diagnostics")
      end, {})
    end,
  },
}
