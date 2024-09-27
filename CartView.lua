local CartView = {}
CartView.__index = CartView

function CartView:new(books)
  local self = setmetatable({}, CartView)
  self.books = books
  self.currentIndex = 1

  self.background = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
  self.background:setFillColor(0, 0, 0, 0.9)

  function onTouch(event) 
    if event.phase == "began" then
      self:openLink() 
    end
  end

  self.infoText = display.newText({
    text = "", 
    x = display.contentCenterX,
    y = display.contentCenterY,
    width = 250,
    font = "Courier",
    fontSize = 12,
    align = "center"
  })
  self.infoText:addEventListener("touch", onTouch)

  self.prevButton = display.newText("Previous", 40, display.contentHeight - 20, "Courier", 8)
  self.prevButton:addEventListener("tap", function() self:showPrevious() end)

  self.nextButton = display.newText("Next", display.contentWidth - 40, display.contentHeight - 20, "Courier", 8)
  self.nextButton:addEventListener("tap", function() self:showNext() end)

  self.closeButton = display.newText("Close", display.contentCenterX, display.contentHeight - 20, "Courier", 8)
  self.closeButton:addEventListener("tap", function() self:close() end)

  self:updateView()
  return self
end

function CartView:openLink()
  local book = self.books[self.currentIndex]
  system.openURL(book.url)
end

function CartView:updateView()
  local book = self.books[self.currentIndex]
  self.infoText.text = book.title .. "\nBy " .. book.authors .. "\n" .. book.price .. "\n (tap to open)"

  self.prevButton.isVisible = self.currentIndex ~= 1
  self.nextButton.isVisible = self.currentIndex < #self.books
end

function CartView:showPrevious()
  if self.currentIndex > 1 then
    self.currentIndex = self.currentIndex - 1
    self:updateView()
  end
end

function CartView:showNext()
  if self.currentIndex < #self.books then
    self.currentIndex = self.currentIndex + 1
    self:updateView()
  end
end

function CartView:close()
  display.remove(self.background)
  display.remove(self.infoText)
  display.remove(self.urlText)
  display.remove(self.prevButton)
  display.remove(self.nextButton)
  display.remove(self.closeButton)
end

return CartView
