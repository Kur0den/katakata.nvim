local M = {}
local mpv_handle = nil

local function get_socket_path()
  if vim.fn.has("win32") == 1 then
    return [[\\.\pipe\katakata-mpv-sock]]
  else
    local runtime_dir = os.getenv("XDG_RUNTIME_DIR") or "/tmp"
    return runtime_dir .. "/katakata-mpv.sock"
  end
end

local function stop_mpv()
  if mpv_handle and not mpv_handle:is_closing() then
    mpv_handle:kill(15)
    mpv_handle:close()
    mpv_handle = nil
  end
end

function M.setup()
  local uv = vim.uv or vim.loop
  local socket_path = get_socket_path()
  mpv_handle, pid = uv.spawn("mpv", {
    args = {"--idle", "--input-ipc-server=" .. socket_path},
    detached = false,
  }, function(code, signal)
    if mpv_handle then
      mpv_handle:close()
      mpv_handle = nil
    end
  end)

  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      if mpv_handle then
        stop_mpv()
      end
    end
  })
  print("Plugin loaded!")
end

function M.hello()
  print("Hello from Plugin!")
  print(get_socket_path())
end



return M
