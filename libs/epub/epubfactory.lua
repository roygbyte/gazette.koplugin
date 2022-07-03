local EpubWriter = require("libs/epub/epubwriter")
local Epub = require("libs/epub/epub")

local EpubFactory = {

}

function EpubFactory:makeWriter(path)
    local epubWriter, err = EpubWriter:new{
        path = path
    }

    if not epubWriter
    then
        return false, err
    end

    return epubWriter
end

function EpubFactory:makeEpub()
    local epub = Epub:new()

    return epub
end

function EpubFactory:makeXHtmlItem(filename, directory, content)

end

return EpubFactory
