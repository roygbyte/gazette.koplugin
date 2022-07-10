local Item = require("libs/gazette/epub/package/item")
local EpubError = require("libs/gazette/epuberror")
local util = require("util")

local Image = Item:new {
   format = nil,
}

Image.SUPPORTED_FORMATS = {
   jpeg = "image/jpeg",
   jpg = "image/jpeg",
   png = "image/png",
   gif = "image/gif",
   svg = "image/svg+xml"
}

function Image:new(o)
   o = o or {}
   self.__index = self
   setmetatable(o, self)

   if not o.path
   then
      return false, EpubError.ITEM_MISSING_PATH
   end
   
   local format, err = o:getFormat(o.path)

   if not format
   then
      return false, EpubError.IMAGE_UNSUPPORTED_FORMAT
   end

   o.media_type = Image.SUPPORTED_FORMATS[format]
   return o
end

function Image:getContent()
    return self.content
end

function Image:fetchContent(data_source)

end

function Image:getFormat(path)
   -- path = path and string.lower(path) or ""
   -- local extension = string.match(path, "[^.]+$")
   local extension = util.getFileNameSuffix(path)
   return Image.SUPPORTED_FORMATS[extension] and
      extension or
      false
end

return Image
