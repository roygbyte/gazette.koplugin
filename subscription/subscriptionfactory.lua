local FeedSubscription = require("subscription/type/feed")
local Feed = require("feed/feed")

local SubscriptionFactory = {

}

SubscriptionFactory.SUBSCRIPTION_TYPES = {
   feed = "feed"
}

function SubscriptionFactory:makeFeed(configuration)
   -- If a feed exists with the ID, it will be loaded.
   feed = FeedSubscription:new({
         id = configuration.id
   })
   -- If the feed wasn't loaded, there'll be no URL in the object.
   -- Likely, we're making a new subscription.
   if not feed.url
   then
      local feed = FeedSubscription:new{
         url = configuration.url,
         limit = configuration.limit,
         download_full_article = configuration.download_full_article,
         download_directory = configuration.download_directory,
         include_images = configuration.include_images,
         enabled_filter = configuration.enabled_filter,
         filter_element = configuration.filter_element,
         feed = configuration.feed
      }
   end

   feed.feed = Feed:new(configuration.feed) or nil

   return feed
end

return SubscriptionFactory
