vim.api.nvim_create_user_command("Hello", function()
  require("katakata").hello()
end, {})

