-- Requirements
local composer = require( "composer" )

-- Vars/Objects local to scene
local scene = composer.newScene()
local prevScene = composer.getSceneName( "previous" )

local function gotoGame()
  composer.gotoScene( "scene.game" )
end

function scene:show( event )
  local sceneGroup = self.view

  local background = display.newImageRect( sceneGroup, "img/menu-background.jpg", 640, 400 )
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  local title = display.newImageRect( sceneGroup, "img/title.png", 250, 80 )
  title.x = display.contentCenterX
  title.y = 50

  local playButton = display.newImageRect( sceneGroup, "img/play-button.png", 100, 50 )
  playButton.x = display.contentCenterX
  playButton.y = 125
  playButton:setFillColor( 0.82, 0.86, 1 )

  playButton:addEventListener( "tap", gotoGame )
end

scene:addEventListener( "show", scene )

return scene
