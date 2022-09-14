local UIManager = require("ui/uimanager")
local KeyValuePage = require("ui/widget/keyvaluepage")
local UIManager = require("ui/uimanager")
local InfoMessage = require("ui/widget/infomessage")
local _ = require("gettext")

local Subscriptions = require("subscription/subscriptions")
local GazetteMessages = require("gazettemessages")
local ViewResults = require("composers/view_results")

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
               Trapper:reset()
               ViewResults:listAll()
            end
         )
   end)
end

function SyncSubscriptions:refresh()
   UIManager:close(self.view)
   SyncSubscriptions:list()
end

return SyncSubscriptions
