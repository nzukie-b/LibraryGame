-- Requirements
local composer = require "composer"
local ponytiled = require "com.ponywolf.ponytiled"
local fx = require "com.ponywolf.ponyfx"
local snd = require "com.ponywolf.ponysound"
local snap = require "com.ponywolf.snap"
local json = require "json"
local app = require "app"
local BookData = require "BookData"

-- Bookdata
bookData = BookData:new()
bookData:loadFiles({
  "bestsellers.json",
  "cozy-mysteries.json",
  "fantasy.json",
  "horror.json",
  "sci-fy.json",
})

-- Variables local to scene
local scene = composer.newScene()
local world, hud, map
local backgroundMusic

function scene:create( event )
  local view = self.view -- add display objects to this group
  local params = event.params or {}

  physics.start()
  physics.setGravity(0,0)
  physics.setDrawMode( "hybrid" )

  -- load world
  self.map = params.map or "house"
  print("Map is ", self.map)
  local worldData = json.decodeFile(system.pathForFile("map/" .. self.map .. ".json"))
  self.world = ponytiled.new(worldData, "map")
  self.world:centerAnchor()

  --standard extensions
  view:insert(self.world)
  self.world:findLayer("physics").isVisible = false
  self.world:toBack()

  --custom extensions
  self.world.extensions = "scene.game.lib."
  self.world:extend("hero", "door", "library-door", "bookshelf")
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
