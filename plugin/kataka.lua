vim.api.nvim_create_user_command("hello", function()
  require("katakata").hello()
end, {})

