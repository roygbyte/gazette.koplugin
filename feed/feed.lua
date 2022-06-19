local RequestFactory = require("libs/http/requestfactory")
local ResponseFactory = require("libs/http/responsefactory")
local GazetteMessages = require("gazettemessages")

local Feed = {
    url = "",
    xml = nil,
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
        return true
    else
        return error(GazetteMessages.ERROR_FEED_FETCH)
    end

    -- Add more definition to the error, if there is one. Check the response codes, message, etc.
end

return Feed
