local UIManager = require("ui/uimanager")
local KeyValuePage = require("ui/widget/keyvaluepage")
local _ = require("gettext")

local Subscriptions = require("subscription/subscriptions")
local ConfigureSubscription = require("composers/configure_subscription")
local ViewSubscriptions = {}

function ViewSubscriptions:list()
   local kv_pairs = {}
   local subscriptions = Subscriptions.all()

   for _, subscription in pairs(subscriptions) do
      -- If a subscription hasn't had its feed value initialized,
      -- this will fail. So, maybe check if the feed is there,
      -- and if not, consider it a good time to update?
      -- Or don't include the subscription in the list?
      table.insert(kv_pairs, {
            subscription:getTitle(),
            subscription:getDescription(),
            callback = function()
               ConfigureSubscription:editFeed(subscription, function()
                     ViewSubscriptions:refresh()
               end)
            end
      })
   end

   self.view = KeyValuePage:new{
         title = _("Subscriptions"),
         value_overflow_align = "right",
         kv_pairs = kv_pairs,
   }

   UIManager:show(self.view)
end

function ViewSubscriptions:refresh()
   UIManager:close(self.view)
   ViewSubscriptions:list()
end

return ViewSubscriptions
