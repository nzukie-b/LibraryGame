-- Requirements
local composer = require "composer"
local ponytiled = require "com.ponywolf.ponytiled"
local fx = require "com.ponywolf.ponyfx"
local snap = require "com.ponywolf.snap"
local json = require "json"
local app = require "app"

-- Variables local to scene
local scene = composer.newScene()
local world, hud, map

-- Collision handler function
local function onCollision(event)
  print(event.object1.name)
  print(event.object2.name)

    if (event.phase == "began") then
        -- Check which objects collided
        local obj1 = event.object1
        local obj2 = event.object2

        if (obj1.name == "hero" and obj2.name == "door1") then
            print("Hero has reached the exit!")
            -- You can trigger a scene change or any other logic here
        end
    end
end

function scene:create( event )
  local view = self.view -- add display objects to this group

  physics.start()
  physics.setGravity(0,0)

  -- load world
  local worldData = json.decodeFile(system.pathForFile("map/house.json"))
  self.world = ponytiled.new(worldData, "map")
  self.world:centerAnchor()

  --standard extensions
  self.world:findLayer("physics").isVisible = true
  self.world:toBack()

  --custom extensions
  self.world.extensions = "scene.game.lib."
  self.world:extend("hero", "door")
  self.world:centerObject("hero")

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