-- tiled Plugin template

-- Use this as a template to extend a tiled object with functionality
local M = {}

local composer = require "composer"
local app = require "app"
local json = require "json"
local fx = require "com.ponywolf.ponyfx"
local snd = require "com.ponywolf.ponysound"
local Alert = require "alert"
local CartView = require("CartView")

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
          local alert = Alert:new(
            "Librarian",
            "Do you want to view your cart?",
            {
              {
                label = "Yes",
                func = function()
                  local booksData = {}
                  for i, bookId in pairs(GlobalData.getCart()) do
                    local book = BookData.findBookById(bookId)
                    table.insert(booksData, {id = id, title = book.title, authors = book.authors, url = book.url, price = book.dealPrice})
                  end

                  CartView:new(booksData)
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
        else
          local alert = Alert:new(
            "Librarian",
            "Your cart is empty, add books and then come back!",
            {
              {
                label = "OK",
                func = function()
                  print("No action")
                end
              },
            }
          )

          snd:play("mhmm")
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
