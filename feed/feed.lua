local RequestFactory = require("libs/http/requestfactory")
local ResponseFactory = require("libs/http/responsefactory")
local FeedError = require("feed/feederror")

local Feed = {
    url = "",
    xml = nil,
    entries = {},
}

function Feed:new(o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)

    return o
end

function Feed:initializeFeedFromXml(xml)
    self.xml = xml
end

function Feed:getDescription()
    return self.subtitle or self.description
end

function Feed:getPermalink()
    return self.link or self.id
end

function Feed:getUpdated()
    return self.pubDate or self.updated
end

function Feed:getLogo()
    return (self.image ~= nil and self.image.url ~= nil) and
        self.image.url or self.logo
end

function Feed:fetch()
    local request = RequestFactory:makeGetRequest(self.url, {})
    local response = request:send()

    if response:canBeConsumed() and
        response:isXml()
    then
        self:initializeFeedFromXml(response.content)
        return true, self
    else
        return false, FeedError:provideFromResponse(response)
    end
end

return Feed
