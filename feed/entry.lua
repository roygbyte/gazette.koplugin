local RequestFactory = require("libs/http/requestfactory")
local FeedError = require("feed/feederror")

local Entry = {
   content = nil
}

function Entry:new(o)
   o = o or {}
   self.__index = self
   setmetatable(o, self)

   return o
end

function Entry:getTitle()
   return self.title
end

function Entry:getSummary()
   return self.summary or self.description
end

function Entry:getPublished()
   return self.pubDate or self.published
end

function Entry:getId()
    return self:getPermalink()
end

function Entry:getPermalink()
   -- ID must preceed link, since Atom entries have
   -- both id and link attributes.
   return self.id or self.link
end

function Entry:fetch()
   if self:getPermalink()
   then
      local request = RequestFactory:makeGetRequest(self:getPermalink(), {})
      local response = request:send()

      if response:canBeConsumed() and
          response:hasContent() and
          response:isOk()
      then
          self.content = response.content
          return true
      else
          return false, FeedError:provideFromResponse(response)
      end
   end
end

function Entry:getAuthor()
   return self.author
end

function Entry:getContent()
    return self.content
end

return Entry
