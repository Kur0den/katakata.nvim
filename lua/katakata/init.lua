local M = {}
local type_sound_count = 4

local last_type_time = 0
local type_threshold = 15

--@alias typesound "normal" | "space" | "tab" | "return"

--@param type typesound
local function type_sound(type)
  local sound_path = nil
  if (type ~= "space") then
    local file_name = string.format("type%02d.wav", math.random(type_sound_count))
    sound_path = "./audio/" .. file_name
  else
    sound_path = "./audio/" .. "space.wav"
  end
  sound_path = vim.fn.fnamemodify(sound_path, ":p")
  vim.system({"aplay", sound_path})
  
  if (type == "return" or type == "tab") then
    sound_path = "./audio/" .. type .. ".wav"
    sound_path = vim.fn.fnamemodify(sound_path, ":p")
    vim.system({"aplay", sound_path})
  end
end

local function bell_sound()
  local sound_path = "./audio/bell.wav"
  sound_path = vim.fn.fnamemodify(sound_path, ":p")
  vim.system({"aplay", sound_path})
end


function M.setup()

  local ns = vim.api.nvim_create_namespace("katakata_key_listener")

  vim.on_key(function(key)
    if key == "" then return end
    
    local mode = vim.api.nvim_get_mode().mode

    if not (mode == "i" or mode == "c" or mode == "t") then return end

    local current_time = vim.loop.hrtime() / 1000000
    if (current_time - last_type_time) < type_threshold then
      last_type_time = current_time
      return
    end
    
    last_type_time = current_time
    
    local k = vim.fn.keytrans(key)
    if k == "<CR>" then
      type_sound("return")
    elseif k == "<Space>" then
      type_sound("space")
    elseif k == "<Tab>" then
      type_sound("tab")
    else
      type_sound("normal")
    end
  end, ns)

  vim.api.nvim_create_autocmd("CompleteDone", {
    pattern = "*",
    callback = function()
      bell_sound()
    end
  })

end

function M.hello()
  print("Hello from Plugin!")
end



return M
