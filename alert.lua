-- Alert.lua

local Alert = {}
Alert.__index = Alert

function Alert:new(title, message, actions)
  local alert = setmetatable({}, self)

  -- Parameters
  alert.title = title
  alert.message = message
  alert.actions = actions or {function() end} -- Default action if none provided
  alert.alertGroup = display.newGroup()
  alert.alertVisible = false

  -- Create the alert display
  alert:createAlert()

  return alert
end

function Alert:createAlert()
  local background = display.newRect(self.alertGroup, display.contentCenterX, display.contentCenterY, 300, 200)
  background:setFillColor(0, 0, 0, 0.9) -- Semi-transparent background

  -- Center-aligned alert title
  local alertTitle = display.newText({
    text = self.title,
    x = display.contentCenterX,
    y = display.contentCenterY - 50,
    width = 200,
    height = 40,
    font = "Courier",
    fontSize = 14,
    align = "center"
  })
  alertTitle:setFillColor(1, 1, 1)
  self.alertGroup:insert(alertTitle)

      -- Center-aligned alert title
  local alertMessage = display.newText({
    text = self.message,
    x = display.contentCenterX,
    y = display.contentCenterY,
    width = 200,
    height = 40,
    font = "Courier",
    fontSize = 12,
    align = "center"
  })
  alertMessage:setFillColor(1, 1, 1)
  self.alertGroup:insert(alertMessage)

  -- Create action buttons
  local buttonSpacing = 20
  for i, action in ipairs(self.actions) do
    local button = display.newText(self.alertGroup, action.label, display.contentCenterX, display.contentCenterY + (i * buttonSpacing), "Courier", 12)
    button:setFillColor(1, 1, 1)

    button:addEventListener("touch", function(event)
      if event.phase == "ended" then
        action.func()
        self:hide()
      end
      return true
    end)
  end
end

function Alert:show()
  physics.pause()
  self.alertVisible = true
end

function Alert:hide()
  physics.start()
  if self.alertGroup then
    self.alertGroup:removeSelf()
    self.alertGroup = nil
    self.alertVisible = false
  end
end

return Alert
