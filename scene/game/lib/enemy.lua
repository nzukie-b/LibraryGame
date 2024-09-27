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

  function instance:collision(event)
    local phase = event.phase
    local other = event.other

    if phase == "began" then
      if other.name == "hero" then
        -- hero touched us
        if other.frameCount < 33 then return end
        other.frameCount = 0

        if table.getn(GlobalData.getCart()) ~= 0 then
          local book = BookData.findBookById(GlobalData.getCartItem())
          local alert = Alert:new(
            "!ENCOUNTER!",
            "What do you know about " .. book.title .. "?\n",
            {
              { 
                label = "I am " .. book.authors,
                func = function()
                  print("Congratulations you're a real Book Bub!")
                  printCart()
                end
              },
              { 
                label = "Nothing...", 
                func = function() 
                  print("No action") 
                end
              },
            }
          )

          alert:show()
        else
          local alert = Alert:new(
            "!ENCOUNTER!",
            "You need more books!",
            {
              { 
                label = "OK", 
                func = function()
                  print("No action") 
                end
              },
            }
          )

          alert:show()
        end

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
