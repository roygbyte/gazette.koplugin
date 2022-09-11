local Subscription = require("subscription/subscription")
local FeedFactory = require("feed/feedfactory")
local socket_url = require("socket.url")
local DataStorage = require("datastorage")

local Feed = Subscription:new{
   subscription_type = "feed",
   url = nil,
   limit = 3,
   download_full_article = true,
   include_images = false,
   enabled_filter = false,
   filter_element = nil,
   download_directory = nil,
}

function Feed:new(o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self

   o:_init(o)
   o = o:load()

   return o
end

function Feed:_init(o)
   -- Call the superclass' init function to apply those values to the
   -- current object.
   getmetatable(self):_init(o)

   self.subscription_type = Feed.subscription_type
   self.url = o.url
   self.limit = o.limit
   self.download_full_article = o.download_full_article
   self.include_images = o.enabled_filter
   self.filter_element = o.filter_element
   -- self.feed isn't initialized here. Instead, it's initialized in the
   -- SubscriptionFactory.
end

function Feed:save()
   self.feed.xml = nil
   -- This is pulled from State:save(). I wanted to call this
   -- through the same getmetatable magic used in _init... but
   -- it "didn't work".
   if not self.id
   then
      self.id = self:generateUniqueId()
   end

   self.lua_settings:saveSetting(self.id, self)
   self.lua_settings:flush()
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

function Feed:setTitle(title)
   self.feed.title = title
end

function Feed:setDescription(description)
   -- This is a strange place to assign the values.
   -- We're operating on the feed data outside of the object.
   -- Why not just move this logic into the feed object?
   if self.feed.subtitle
   then
      self.feed.subtitle = description
   elseif self.feed.description
   then
      self.feed.description = description
   end
end

function Feed:setDownloadDirectory(path)
   self.download_directory = path
end

function Feed:getDownloadDirectory()
   if self.download_directory
   then
      print(self.download_directory)
      return self.download_directory
   else
      return DataStorage:getDataDir() .. "/news/"
   end
end

return Feed
