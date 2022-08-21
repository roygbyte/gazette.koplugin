local FeedSubscription = require("subscription/type/feed")
local Feed = require("feed/feed")

local SubscriptionFactory = {

}

SubscriptionFactory.SUBSCRIPTION_TYPES = {
   feed = "feed"
}

function SubscriptionFactory:makeFeed(configuration)
   -- Do I need to assign the values... or can I just pass the configuration table?
   return FeedSubscription:new{
      url = configuration.url,
      limit = configuration.limit,
      download_full_article = configuration.download_full_article,
      include_images = configuration.include_images,
      enabled_filter = configuration.enabled_filter,
      filter_element = configuration.filter_element,
      feed = Feed:new(configuration.feed) or nil
   }
end

return SubscriptionFactory
