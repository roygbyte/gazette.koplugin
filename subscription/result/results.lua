local DataStorage = require("datastorage")
local LuaSettings = require("frontend/luasettings")

local State = require("subscription/state")
local SubscriptionSyncResult = require("subscription/result/subscription_sync_result")
local ResultsFactory = require("subscription/result/resultsfactory")

local Results = State:new{
   lua_settings = nil,
   STATE_FILE = SubscriptionSyncResult.STATE_FILE,
}

function Results:new(o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o:init()
   return o
end

function Results:all()
   local initialized_results = {}

   if not self
   then
      self = Results:new{}
   end

   for id, data in pairs(self.lua_settings.data) do
      local results = ResultsFactory:makeResults(data)
      initialized_results[id] = results
   end

   return initialized_results
end

function Results.forFeed(id)
   local results = Results.all()

   for _, subscription_sync_results in pairs(results) do
      if subscription_sync_results.subscription_id == id and
         type(subscription_sync_results) == "table"
      then
         return subscription_sync_results
      end
   end

   return false
end

function Results.getMostRecentForSubscription(subscription_id)

end

return Results
