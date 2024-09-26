local json = require("json")  -- Ensure you're using the appropriate JSON library

local BookData = {}
BookData.__index = BookData

-- Constructor
function BookData:new()
    local instance = {
        categories = {},         -- Store category names
        booksByCategory = {}
    }
    setmetatable(instance, BookData)
    return instance
end

-- Load JSON files into categories
function BookData:loadFiles(fileList)
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
            self.booksByCategory[categoryName] = self.booksByCategory[categoryName] or {}
            self.categories[categoryName] = true  -- Store category name

            print(categoryName)

            for _, book in ipairs(decoded) do
                self.booksByCategory[categoryName][book.id] = book
            end
        else
            error("Could not open file: " .. fullPath)
        end
    end

    -- Convert categories table to a list
    self.categories = self:convertCategoriesToList()
end

-- Helper function to convert category keys to a list
function BookData:convertCategoriesToList()
    local categoryList = {}
    for categoryName in pairs(self.categories) do
        table.insert(categoryList, categoryName)
    end
    return categoryList
end

-- Return a list of books for a specific category formatted as {id, title}
function BookData:getBookList(category)
    local bookList = {}
    if self.booksByCategory[category] then
        for id, book in pairs(self.booksByCategory[category]) do
            table.insert(bookList, {id = id, title = book.title})
        end
    end
    return bookList
end

-- Get the data blob for a specific ID in a category
function BookData:getBookById(category, id)
    if self.booksByCategory[category] then
        return self.booksByCategory[category][id]
    end
    return nil
end

-- Get the list of category names
function BookData:getCategories()
    return self.categories
end

return BookData
