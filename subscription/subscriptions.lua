local DataStorage = require("datastorage")
local LuaSettings = require("frontend/luasettings")

local SubscriptionFactory = require("subscription/subscriptionfactory")
local SubscriptionBuilder = require("views/subscription_builder")
local State = require("subscription/state")

local Subscriptions = {
   lua_settings = nil
}

function Subscriptions:new(o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o:init()
   return o
end

function Subscriptions:init()
   self.lua_settings = LuaSettings:open(("%s/%s"):format(State.DATA_STORAGE_DIR, State.STATE_FILE))

   if not self.lua_settings
   then
      return false
   end
end

function Subscriptions:all()
   local initialized_subscriptions = {}

   if not self
   then
      self = Subscriptions:new{}
   end

   for id, data in pairs(self.lua_settings.data) do
      if data.subscription_type and
         data.subscription_type == "feed"
      then
         local subscription = SubscriptionFactory:makeFeed(data)
         initialized_subscriptions[id] = subscription
      end
   end

   return initialized_subscriptions
end

function Subscriptions:sync(progress_callback, finished_callback)
   local initialized_subscriptions = Subscriptions.all()
   local results = {}

   for id, subscription in pairs(initialized_subscriptions) do
      subscription:sync()

      local subscription_result = {
         title = subscription:getTitle(),
         description = #subscription.feed.entries
      }
      local entry_results = {}

      local limit = subscription.limit
      local count = 0
      for _, entry in pairs(subscription.feed.entries) do
         progress_callback(subscription:getTitle() .. ": " .. entry:getTitle())
         local result, err = SubscriptionBuilder:buildSingleEntry(subscription, entry)
         local description = result or err
         table.insert(entry_results, {
               title = entry:getTitle(),
               description = description
         })
         count = count + 1
         if count > limit
         then
            break
         end
      end

      subscription_result.entry_results = entry_results
      table.insert(results, subscription_result)
   end

   finished_callback(results)
end

return Subscriptions
