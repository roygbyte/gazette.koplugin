local Subscription = require("subscription/subscription")
local SubscriptionFactory = require("subscription/subscriptionfactory")
local FeedFactory = require("feed/feedfactory")

local Feed = Subscription:new{
   subscription_type = "feed",
   url = nil,
   limit = 3,
   download_full_article = true,
   include_images = false,
   enabled_filter = false,
   filter_element = nil,
}

function Feed:new(o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self

   o:_init(o)
   o:load()

   return o
end

function Feed:_init(o)
   -- Call the superclass' init function to apply those values to the
   -- current object.
   getmetatable(self):_init(o)

   self.url = o.url
   self.limit = o.limit
   self.download_full_article = o.download_full_article
   self.include_images = o.enabled_filter
   self.filter_element = o.filter_element

   print(self.subscription_type)
end

function Feed:sync()
   local feed, err = FeedFactory:make(self.url)

   if err
   then
      return false, err
   end

   local feed, err = feed:fetch()

   if err
   then
      return false, err
   end

   self.feed = feed
   self:onSuccessfulSync()

   return true
end

function Feed:isUrlValid(url)
   if not url or
      not type(url) == "string"
   then
      return false
   end

   local parsed_url = socket_url.parse(url)

   if parsed_url.host
   then
      return true
   else
      return false
   end
end

function Feed:getTitle()
   return self.feed.title
end

function Feed:getDescription()
   return self.feed:getDescription()
end

return Feed
