local Result = require("subscription/result/result")
local SubscriptionSyncResult = require("subscription/result/subscription_sync_result")

local ResultsFactory = {}

function ResultsFactory:makeResults(data)
   local results = SubscriptionSyncResult:new({
         id = data.id,
         results = data.results
   })
   results:initializeResults()

   return results
end

return ResultsFactory
