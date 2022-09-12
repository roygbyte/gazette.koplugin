local DataStorage = require("datastorage")
local LuaSettings = require("frontend/luasettings")

local State = require("subscription/state")
local SubscriptionSyncResult = require("subscription/result/subscription_sync_result")
local ResultsFactory = require("subscription/result/resultsfactory")

local Results = {
   lua_settings = nil
}

function Results:new(o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o:init()
   return o
end

function Results:init()
   self.lua_settings = LuaSettings:open(("%s/%s"):format(State.DATA_STORAGE_DIR, SubscriptionSyncResult.STATE_FILE))

   if not self.lua_settings
   then
      return false
   end
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
   if results[id] and
      type(results[id]) == "table"
   then
      return results[id]
   else
      return false
   end
end

return Results
