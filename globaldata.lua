local GlobalData = {}
GlobalData.__index = GlobalData

-- Static properties
GlobalData.cart = {}
GlobalData.activeCategory = ""

-- Method to get the cart
function GlobalData.getCart()
  return GlobalData.cart
end

-- Method to add a unique item to the cart
function GlobalData.addToCart(item)
  -- Check if the item already exists in the cart
  for _, existingItem in ipairs(GlobalData.cart) do
    if existingItem == item then
      return  -- Item already exists, do nothing
    end
  end

  -- If it doesn't exist, add it to the cart
  table.insert(GlobalData.cart, item)
end

-- Method to set the cart (optional)
function GlobalData.setCart(newCart)
  GlobalData.cart = newCart
end

-- Method to get the active category
function GlobalData.getCategory()
  return GlobalData.activeCategory
end

-- Method to set the active category
function GlobalData.setCategory(newCategory)
  if type(newCategory) == "string" then  -- Ensure it's a string
    GlobalData.activeCategory = newCategory
  else
    error("activeCategory must be a string")
  end
end

return GlobalData