-- alert.lua

local Alert = {}
Alert.__index = Alert

function Alert:new(title, message, actions)
    local alert = setmetatable({}, self)
    
    -- Parameters
    alert.title = title
    alert.message = message
    alert.actions = actions or {"OK"} -- Default action if none provided
    alert.alertGroup = display.newGroup()
    alert.alertVisible = false
    
    -- Create the alert display
    alert:createAlert()
    
    return alert
end

function Alert:createAlert()
    local background = display.newRect(self.alertGroup, display.contentCenterX, display.contentCenterY, 300, 200)
    background:setFillColor(0, 0, 0, 0.9) -- Semi-transparent background

    -- Center-aligned alert text
    local alertTitle = display.newText({
        text = "\"" .. self.title .. "\"",
        x = display.contentCenterX,
        y = display.contentCenterY - 40,
        font = "Courier",
        fontSize = 16,
        align = "center"
    })
    alertTitle:setFillColor(1, 1, 1)
    self.alertGroup:insert(alertTitle)

    local alertMessage = display.newText({
        text = self.message,
        x = display.contentCenterX,
        y = display.contentCenterY - 20,
        font = "Courier",
        fontSize = 14,
        align = "center"
    })
    alertMessage:setFillColor(1, 1, 1)
    self.alertGroup:insert(alertMessage)

    -- Create action buttons
    local buttonSpacing = 20
    for i, action in ipairs(self.actions) do
        local button = display.newText(self.alertGroup, action, display.contentCenterX, display.contentCenterY + (i * buttonSpacing), "Courier", 12)
        button:setFillColor(1, 1, 1)
        button.action = action

        button:addEventListener("touch", function(event)
            if event.phase == "ended" then
                self:handleAction(button.action)
            end
            return true
        end)
    end
end

function Alert:handleAction(action)
    print("Alert: " .. action .. " clicked!")
    self:hide()
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
