describe("Subscription", function()
      local logger
      local subscription_id_to_persist
      setup(function()
            orig_path = package.path
            package.path = "plugins/gazette.koplugin/?.lua;" .. package.path
            require("commonrequire")
            Subscription = require("subscription/subscription")
            Subscriptions = require("subscription/subscriptions")
            FeedSubscription = require("subscription/type/feed")
            State = require("subscription/state")
            logger = require("logger")
            our_world_in_data_feed = "https://ourworldindata.org/atom.xml"
      end)
      teardown(function()
            State:deleteConfig()
      end)
      describe("Subscription", function()
            it("should generate a unique ID for each new subscription", function()
                  local subscription_1 = Subscription:new()
                  subscription_1.url = our_world_in_data_feed
                  subscription_1:save()
                  subscription_id_to_persist = subscription_1.id
                  local subscription_2 = Subscription:new()
                  subscription_2:save()
                  assert.are_not.same(subscription_1.id, subscription_2.id)
            end)
            it("should persist its values", function()
                  local subscription = Subscription:new({
                        id = subscription_id_to_persist
                  })
                  -- subscription:load()
                  subscription:save()
                  assert.are.same(subscription_id_to_persist, subscription.id)
                  assert.are.same(our_world_in_data_feed, subscription.url)
            end)
            it("should deleted when delete method is invoked", function()
                  local subscription = Subscription:new({
                        id = subscription_id_to_persist
                  })
                  subscription:delete()

                  local no_subscription = Subscription:new({
                        id = subscription_id_to_persist
                  })
                  assert.are.same(false, no_subscription)
            end)
      end)
      describe("FeedSubscription", function()
            local feed_subscription_id
            local feed_entries_last_update
            it("should create and save a new feed subscription", function()
                  local subscription = FeedSubscription:new()
                  subscription.url = our_world_in_data_feed
                  subscription:sync()
                  local ok, err = subscription:save(subscription)
                  feed_subscription_id = subscription.id
                  feed_entries_last_update = subscription.feed.updated
                  assert.are_not.same(false, ok)
            end)
            it("should find previously saved feed subscription's latest entries", function()
                  local subscription = FeedSubscription:new({
                        id = feed_subscription_id
                  })
                  assert.are.same(feed_entries_last_update, subscription.feed.updated)
            end)
            it("should contain re-initialized feed object when feed subscription is loaded from saved state", function()
                  local subscription = FeedSubscription:new({
                        id = feed_subscription_id
                  })
                  assert.is.truthy(subscription.feed:getDescription())
            end)
            it("should use default feed subscription config if none set", function()
                  local subscription = FeedSubscription:new({
                        id = feed_subscription_id
                  })
                  assert.are.same(FeedSubscription.limit, subscription.limit)
            end)
            it("should indicate the correct type of subscription", function()
                  local subscription = FeedSubscription:new({
                        id = feed_subscription_id
                  })
                  assert.are.same(FeedSubscription.subscription_type, subscription.subscription_type)
            end)
            -- Find and create the right type of subscription from the history file.
      end)
      describe("Subscriptions", function()
            it("should list all subscriptions", function()
                  local subscriptions = Subscriptions.all()

                  for _, subscription in pairs(subscriptions) do
                     assert.are.same("Our World in Data", subscription.feed.title)
                  end
            end)
      end)
end)
