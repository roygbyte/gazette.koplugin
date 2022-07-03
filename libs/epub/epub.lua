local Nav = require("libs/epub/item/nav")
local Package = require("libs/epub/package")

local Epub = Package:new{

}

function Epub:new(o)
    o = Package:new()

    self.__index = self
    setmetatable(o, self)

    return o
end

-- Need a way to add a Webpage, which is an XHtmlItem and possibly images, scripts, and styles.

return Epub
