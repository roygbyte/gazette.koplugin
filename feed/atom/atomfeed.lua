local Feed = require("feed/feed")
local EntryFactory = require("feed/entryfactory")
local GazetteMessages = require("gazettemessages")
local util = require("util")

local AtomFeed = Feed:new {
    id = nil,
    title = nil,
    subtitle = nil,
    updated = nil,
    author = {
        name = nil,
        email = nil,
        uri = nil,
    },
    category = nil,
    contributor = nil,
    generator = nil,
    icon = nil,
    logo = nil,
    rights = nil,
    entries = {},
}

function AtomFeed:new(o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)

    o:initializeFeedFromXml(o.xml)

    return o
end

function AtomFeed:initializeFeedFromXml(xml)
    local channel = xml.feed
    self.id = channel.id
    self.title = util.htmlEntitiesToUtf8(channel.title or GazetteMessages.UNTITLED_FEED)
    self.subtitle = channel.subtitle
    self.updated = channel.updated
    self.author = channel.author ~= nil and {
        name = channel.author.name,
        email = channel.author.email,
        uri = channel.author.uri
    } or nil
    self.category = channel.category
    self.contributor = channel.contributor
    self.generator = channel.generator
    self.icon = channel.icon
    self.logo = channel.logo
    self.rights = channel.rights
    self.entries = {}
    self:initializeEntries(channel.entry)
end

function AtomFeed:initializeEntries(entriesAsXml)
    for index, entry in ipairs(entriesAsXml) do
        local entry = EntryFactory:makeAtom(entry)
        table.insert(self.entries, entry)
    end
end

return AtomFeed
