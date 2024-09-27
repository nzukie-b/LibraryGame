local json = require("json")  -- Ensure you're using the appropriate JSON library

local BookData = {}
BookData.categories = {}
BookData.booksByCategory = {}

-- Load JSON files into categories
function BookData.loadFiles(fileList)
  for _, fileName in ipairs(fileList) do
    local fullPath = system.pathForFile("book_data/" .. fileName, system.ResourceDirectory)
    local file = io.open(fullPath, "r")
    if file then
      local content = file:read("*all")
      file:close()

      local decoded, pos, err = json.decode(content)
      if err then
        error("Error in JSON file: " .. err)
      end

      -- Use the filename (without extension) as the category
      local categoryName = fileName:match("([^%.]+)")  -- Remove the extension
      BookData.booksByCategory[categoryName] = BookData.booksByCategory[categoryName] or {}
      BookData.categories[categoryName] = true  -- Store category name

      for _, book in ipairs(decoded) do
        BookData.booksByCategory[categoryName][book.id] = book
      end
    else
      error("Could not open file: " .. fullPath)
    end
  end

  -- Convert categories table to a list
  BookData.categories = BookData.convertCategoriesToList()
end

-- Helper function to convert category keys to a list
function BookData.convertCategoriesToList()
  local categoryList = {}
  for categoryName in pairs(BookData.categories) do
    table.insert(categoryList, categoryName)
  end

  return categoryList
end

-- Return a list of books for a specific category formatted as {id, title}
function BookData.getBookList(category)
  local bookList = {}
  if BookData.booksByCategory[category] then
    for id, book in pairs(BookData.booksByCategory[category]) do
      table.insert(bookList, {id = id, title = book.title})
    end
  end

  return bookList
end

-- Get the data blob for a specific ID in a category
function BookData.getBookById(category, id)
  if BookData.booksByCategory[category] then
    return BookData.booksByCategory[category][id]
  end

  return nil
end

-- Get the book by only the ID. This will iterate over all categories
function BookData.findBookById(id)
  for category, books in pairs(BookData.booksByCategory) do
    if books[id] then
      return books[id]  -- Return the book if found
    end
  end
  return nil  -- Return nil if not found
end

-- Get the list of category names
function BookData.getCategories()
  return BookData.categories
end

BookData.loadFiles({
  "bestsellers.json",
  "cozy-mysteries.json",
  "fantasy.json",
  "horror.json",
  "sci-fi.json",
})


return BookData
