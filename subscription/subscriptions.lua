local DataStorage = require("datastorage")
local LuaSettings = require("frontend/luasettings")

local SubscriptionFactory = require("subscription/subscriptionfactory")
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

return Subscriptions