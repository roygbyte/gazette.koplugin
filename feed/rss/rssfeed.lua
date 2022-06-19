local Feed = require("feed/feed")
local GazetteMessages = require("gazettemessages")
local util = require("util")

local RssFeed = Feed:new {
    title = nil,
    link = nil,
    description = nil,
    webMaster = nil,
    managingEditor = nil,
    copyright = nil,
    pubDate = nil,
    lastBuildDate = nil,
    category = nil,
    generator = nil,
    image = {
      url = nil,
      title = nil,
      link = nil,
    },
    skipHours = nil,
    skipDays = nil,
}

function RssFeed:new(o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)

    o:initializeFeedFromXml(o.xml)

    return o
end

function RssFeed:initializeFeedFromXml(xml)
    local channel = xml.rss.channel
    self.title = util.htmlEntitiesToUtf8(channel.title or GazetteMessages.UNTITLED_FEED)
    self.link = channel.link
    self.description = channel.description
    self.webMaster = channel.description
    self.managingEditor = channel.description
    self.copyright = channel.copyright
    self.pubDate = channel.pubDate
    self.lastBuildDate = channel.lastBuildDate
    self.category = channel.category
    self.generator = channel.generator
    self.image = channel.image ~= nil and {
        url = channel.image.url,
        title = channel.image.title,
        link = channel.image.link
    } or nil
    self.skipHours = channel.skipHours
    self.skipDays = channel.skipDays
end

return RssFeed
