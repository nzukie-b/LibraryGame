-- Requirements
local composer = require "composer"
local ponytiled = require "com.ponywolf.ponytiled"
local fx = require "com.ponywolf.ponyfx"
local snd = require "com.ponywolf.ponysound"
local snap = require "com.ponywolf.snap"
local json = require "json"
local app = require "app"

-- Global States
GlobalData = require "GlobalData"
BookData = require "BookData"

-- Debug Helper
function printTable(t, indent)
  indent = indent or 0
  local spacing = string.rep("  ", indent)

  for key, value in pairs(t) do
    if type(value) == "table" then
      print(spacing .. tostring(key) .. ":")
      printTable(value, indent + 1)  -- Recursive call for nested tables
    else
      print(spacing .. tostring(key) .. ": " .. tostring(value))
    end
  end
end

-- Cart Logger
function printCart() 

  local booksData = {}
  for i, bookId in pairs(GlobalData.getCart()) do
    local book = BookData.findBookById(bookId)
    table.insert(booksData, {id = id, title = book.title, authors = book.authors, url = book.url, price = book.dealPrice})
  end

  printTable(booksData)
end

-- Variables local to scene
local scene = composer.newScene()
local world, hud, map
local backgroundMusic

function scene:create( event )
  local view = self.view -- add display objects to this group
  local params = event.params or {}

  physics.start()
  physics.setGravity(0,0)
  -- physics.setDrawMode( "hybrid" )

  -- load world
  self.map = params.map or "house"
  local worldData = json.decodeFile(system.pathForFile("map/" .. self.map .. ".json"))
  self.world = ponytiled.new(worldData, "map")
  self.world:centerAnchor()

  --standard extensions
  view:insert(self.world)
  self.world:findLayer("physics").isVisible = false
  self.world:toBack()

  --custom extensions
  self.world.extensions = "scene.game.lib."
  self.world:extend("hero", "door", "library-door", "book", "info", "enemy")
  self.world:centerObject("hero")

  backgroundMusic = snd:loadMusic( "snd/bgmusic.mp3" )
  snd:setMusicVolume(0.1)
end

local function enterFrame(event)
  local elapsed = event.time
  -- Do these every frame regardless of pause
  local world = scene.world
  world:sortLayer("game")
  world:centerObject("hero", true)
  world:boundsCheck()

end

function scene:pause()
  Runtime:removeEventListener("enterFrame", enterFrame)
end

function scene:resume()
  Runtime:addEventListener("enterFrame", enterFrame)
end

function scene:show( event )
  local phase = event.phase
  if ( phase == "will" ) then
    Runtime:addEventListener("enterFrame", enterFrame)
  elseif ( phase == "did" ) then
    snd:playMusic()
    fx.fadeIn()
  end
end

function scene:hide( event )
  local phase = event.phase
  if ( phase == "will" ) then

  elseif ( phase == "did" ) then
    Runtime:removeEventListener("enterFrame", enterFrame)
  end
end

function scene:destroy( event )

end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene
