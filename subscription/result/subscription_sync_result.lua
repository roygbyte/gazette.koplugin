local md5 = require("ffi/sha2").md5

local State = require("subscription/state")
local ResultFactory = require("subscription/result/resultfactory")

local SubscriptionSyncResult = State:new{
   STATE_FILE = "gazette_results.lua",
   results = nil
}

function SubscriptionSyncResult:new(o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self

   -- This should try and load existing results... like subscription, really
   -- o:_init()
   if o.results == nil
   then
      o.results = {}
   end

   return o
end

function SubscriptionSyncResult:add(result)
   local hashed_url = md5(result:getId())
   self.results[hashed_url] = result
end

function SubscriptionSyncResult:initializeResults()
   if self.results == nil or
      type(self.results) ~= "table"
   then
      return false
   end

   local initialized_results = {}

   for id, data in pairs(self.results) do
      initialized_results[id] = ResultFactory:makeResult(data)
   end

   self.results = initialized_results

   return true
end

function SubscriptionSyncResult:hasEntry(entry)
   local hashed_url = md5(entry:getId())
   if self.results[hashed_url]
   then
      return true
   else
      return false
   end
end

function SubscriptionSyncResult:totalSuccesses()
   local successes = 0
   for _, result in pairs(self.results) do
      if result:isSuccessful()
      then
         successes = successes + 1
      end
   end
   return successes
end

function SubscriptionSyncResult:getResultCount()
   local count = 0
   for _,_ in pairs(self.results) do
      count = count + 1
   end
   return count
end

return SubscriptionSyncResult