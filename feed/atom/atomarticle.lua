local Article = require("feed/article")

local AtomArticle = Article:new {
    id = nil,
    updated = nil,
    link = {
        rel = nil,
        href = nil
    },
    summary = nil,
    authors = {
        name = nil
    },
    title = nil,
    published = nil
}

function AtomArticle:new(o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)

    return o
end

return AtomArticle
