local M = {}
local type_sound_count = 4

local last_type_time = 0
local type_threshold = 15

--@alias typesound "normal" | "space" | "indent" | "enter"

--@param type typesound
local function play_sound(type)
  local file_name = string.format("type%02d.wav", math.random(type_sound_count))
  local sound_path = "./audio/" .. file_name
  sound_path = vim.fn.fnamemodify(sound_path, ":p")
  vim.system({"aplay", sound_path}, 
    function(job)
    end
  )

end


function M.setup()

  local ns = vim.api.nvim_create_namespace("katakata_key_listener")

  vim.on_key(function(key)
    if key == "" then return end
    
    local current_time = vim.loop.hrtime() / 1000000

    if (current_time - last_type_time) < type_threshold then
      last_type_time = current_time
      return
    end
    
    last_type_time = current_time

    play_sound("normal")
  end, ns)

  print("Plugin loaded!")
end

function M.hello()
  print("Hello from Plugin!")
end



return M
