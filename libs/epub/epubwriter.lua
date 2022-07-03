local EpubError = require("libs/epub/epuberror")
local ZipWriter = require("ffi/zipwriter")
local xml2lua = require("libs/xml2lua/xml2lua")

local EpubWriter = ZipWriter:new {
    path = nil,
    temp_path = nil,
}

function EpubWriter:new(o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)

    local ok, err = o:isOutputAvailable()
    if not ok
    then
        return false, err
    end

    return o
end

function EpubWriter:buildEpub(epub)
    local ok, err = self:openTempPath()
    if not ok
    then
        return false, EpubError.EPUBWRITER_INVALID_PATH
    end

    self:addMimetype()
    self:addContainer()
    self:addPackage(epub:getPackageXml())
    self:addItems(epub:getManifestItems())

    self:close()
    os.rename(self.temp_path, self.path)

    return true
end

function EpubWriter:addMimetype()
    self:add("mimetype", "application/epub+zip")
end

function EpubWriter:addContainer()
    local container = EpubWriter:getPart("container.xml")
    self:add("META-INF/container.xml", container)
end

function EpubWriter:addPackage(packagio)
    self:add("OPS/package.opf", packagio)
end

function EpubWriter:addItems(items)
    for _, item in ipairs(items) do
        local content = item:getContent()
        if content
        then
            self:add("OPS/" .. item.path, content)
        end
    end
end

function EpubWriter:openTempPath()
    self.temp_path = self.path .. ".tmp"

    if not self:open(self.temp_path)
    then
        return false, EpubError.EPUBWRITER_INVALID_PATH
    else
        return true
    end
end

function EpubWriter:isOutputAvailable()
    local test_path = self.path

    if not self:open(test_path)
    then
        return false, EpubError.EPUBWRITER_INVALID_PATH
    else
        self:close()
        os.remove(test_path)
        return true
    end
end

function EpubWriter:getPart(filename)
    local file, err = xml2lua.loadFile("plugins/gazette.koplugin/libs/epub/templates/" .. filename)
    if file
    then
        return file
    else
        return false, err
    end
end

return EpubWriter
