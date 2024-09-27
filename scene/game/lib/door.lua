-- tiled Plugin template

-- Use this as a template to extend a tiled object with functionality
local M = {}

local composer = require "composer"
local app = require "app"
local json = require "json"
local fx = require "com.ponywolf.ponyfx"
local snd = require "com.ponywolf.ponysound"
local Alert = require "alert"

function M.new(instance)

  if not instance then error("ERROR: Expected display object") end
  local scene = composer.getScene("scene.game")
  local title = BookData.getCategories()[instance.id]

  function instance:collision(event)
    local phase = event.phase
    local other = event.other

    if phase == "began" then
      if other.name == "hero" then
        -- hero touched us
        if other.frameCount < 33 then return end
        other.frameCount = 0

        snd:play("door-open")

        -- Create and show the custom alert
        local alert = Alert:new(
            string.upper(title),
            "Do you want to enter?",
            {
              { 
                label = "Yes", 
                func = function()
                  GlobalData.setCategory(title)
                  composer.gotoScene("scene.refresh", { params = { map = "library1" }})
                end 
              },
              { label = "No", func = function() print("No action") end },
            }
        )

        alert:show()

      end
    end
  end

  function instance:preCollision(event)
    local other = event.other

  end

  -- Add our collision listeners
  instance:addEventListener("preCollision")
  instance:addEventListener("collision")

  return instance
end

return M
