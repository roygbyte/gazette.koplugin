describe("Subscription", function()
      local logger
      local subscription_id_to_persist
      setup(function()
            orig_path = package.path
            package.path = "plugins/gazette.koplugin/?.lua;" .. package.path
            require("commonrequire")
            Subscription = require("subscription/subscription")
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
            it("should use default feed subscription config if none set", function()
                  local subscription = FeedSubscription:new({
                        id = feed_subscription_id
                  })
                  assert.are.same(FeedSubscription.limit, subscription.limit)
            end)
            -- Find and create the right type of subscription from the history file.
      end)
end)
