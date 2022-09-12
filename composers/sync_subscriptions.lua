local UIManager = require("ui/uimanager")
local KeyValuePage = require("ui/widget/keyvaluepage")
local UIManager = require("ui/uimanager")
local InfoMessage = require("ui/widget/infomessage")
local _ = require("gettext")

local Subscriptions = require("subscription/subscriptions")
local GazetteMessages = require("gazettemessages")

local SyncSubscriptions = {}

function SyncSubscriptions:sync()
   local Trapper = require("ui/trapper")
   Trapper:wrap(function()
         Trapper:info(GazetteMessages.SYNC_SUBSCRIPTIONS_SYNC)
         local subscriptions = Subscriptions:sync(
            function(update)
               Trapper:info(update)
            end,
            function(results)
               SyncSubscriptions:results(results)
            end
         )
   end)
end

function SyncSubscriptions:results(results)
   local kv_pairs = {}

   for _, subscription_result in pairs(results) do
      table.insert(kv_pairs, {
            subscription_result.title,
            subscription_result.description,
            callback = function()
               require("logger").dbg(subscription_result.entry_results)
            end
      })
   end

   self.view = KeyValuePage:new{
         title = _("Sync Results"),
         value_overflow_align = "right",
         kv_pairs = kv_pairs,
   }

   UIManager:show(self.view)
end

function SyncSubscriptions:refresh()
   UIManager:close(self.view)
   SyncSubscriptions:list()
end

return SyncSubscriptions
