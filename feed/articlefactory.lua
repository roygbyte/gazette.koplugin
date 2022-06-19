local Article = require("feed/article")
local AtomArticle = require("feed/atom/atomarticle")

local ArticleFactory = {

}

function ArticleFactory:makeAtom(entryAsXml)
    local authors = {}

    for index, name in ipairs(entryAsXml.author) do
        table.insert(authors, name)
    end

    return AtomArticle:new{
        id = entryAsXml.id,
        updated = entryAsXml.updated,
        link = (entryAsXml.link ~= nil and entryAsXml.link._attr ~= nil)
            and {
                rel = entryAsXml.link._attr.rel,
                href = entryAsXml.link._attr.href,
            } or nil,
        summary = entryAsXml.summary,
        author = authors,
        title = entryAsXml.title,
        published = entryAsXml.published,
    }
end

return ArticleFactory
