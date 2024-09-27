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

        -- Pull Book Data
        local category = GlobalData.getCategory()
        local bookInfo = BookData.getBookList(category)[instance.id]
        local bookTitle = bookInfo['title']
        local bookId = bookInfo['id']

        -- Create and show the custom alert
        local alert = Alert:new(
          bookTitle,
          "Add to cart?",
          {
            {
              label = "Yes",
              func = function()
                snd:play("coin")
                GlobalData.addToCart(bookId)
              end
            },
            { 
              label = "No", 
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

  function instance:preCollision(event)
    local other = event.other
  end

  -- Add our collision listeners
  instance:addEventListener("preCollision")
  instance:addEventListener("collision")

  return instance
end

return M
