local UIManager = require("ui/uimanager")
local EditDialog = require("views/subscription_edit_dialog")
local FeedFactory = require("feed/feedfactory")
local SubscriptionFactory = require("subscription/subscriptionfactory")

local UIManager = require("ui/uimanager")
local InfoMessage = require("ui/widget/infomessage")
local GazetteMessages = require("gazettemessages")
local Screen = require("device").screen
local T = require("ffi/util").template

local ConfigureSubscription = {

}

function ConfigureSubscription:editFeed()
   UIManager:show(EditDialog:addSubscription(self))
end

function ConfigureSubscription:testFeed(dialog)
   local Trapper = require("ui/trapper")
   Trapper:info(GazetteMessages.CONFIGURE_SUBSCRIPTION_TEST_FEED_BEGIN)

   local subscription, err = ConfigureSubscription:createFeedFromDialog(dialog)

   if not subscription
   then
      local error_message = T(GazetteMessages.CONFIGURE_SUBSCRIPTION_TEST_ERROR, err)
      Trapper:info(error_message)
      return false
   end

   Trapper:info(GazetteMessages.CONFIGURE_SUBSCRIPTION_TEST_FETCH_URL)
   local success, err = subscription:sync() --FeedFactory:make(subscription.url)

   if not success
   then
      local error_message = T(GazetteMessages.CONFIGURE_SUBSCRIPTION_TEST_ERROR, err)
      Trapper:info(error_message)
      return false
   end

   local success_message = T(GazetteMessages.CONFIGURE_SUBSCRIPTION_TEST_SUCCESS, subscription.feed.title)
   print(subscription.feed:getDescription())
   Trapper:info(success_message)

   return subscription
end

function ConfigureSubscription:saveFeed(feed)
   feed:save()
end

function ConfigureSubscription:createFeedFromDialog(dialog)
   local fields = dialog:getFields()

   local configuration = {
      url = fields[1]
   }

   return SubscriptionFactory:makeFeed(configuration)
end

return ConfigureSubscription
