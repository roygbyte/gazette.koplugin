local EpubError = require("libs/gazette/epuberror")
local Item = require("libs/gazette/epub/package/item")
local md5 = require("ffi/sha2").md5
local util = require("util")

local XHtmlItem = Item:new {
    title = "Untitled Document",
}

function XHtmlItem:new(o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)

    if not o.path
    then
        return false, EpubError.ITEM_MISSING_PATH
    end

    o.path = util.urlEncode(o.path)
    o.media_type = "application/xhtml+xml"
    o:generateId()

    return o
end

return XHtmlItem
