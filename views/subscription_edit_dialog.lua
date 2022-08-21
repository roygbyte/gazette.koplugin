local MultiInputDialog = require("ui/widget/multiinputdialog")
local UIManager = require("ui/uimanager")
local _ = require("gettext")

local GazetteMessages = require("gazettemessages")

local EditDialog = {

}

function EditDialog:addSubscription(composer)
   local dialog
   local passed_test = false
   local subscription
   dialog = MultiInputDialog:new{
      title = _("Add a RSS or Atom feed"),
      fields = {
         {
            description = _("URL"),
            text = _("https://"),
            hint = _("URL"),
         },
      },
      buttons = {
         {
            {
               text = _("Cancel"),
               id = "close",
               callback = function()
                  UIManager:close(sample_input)
               end
            },
            {
               text = _("Test"),
               callback = function()
                  local Trapper = require("ui/trapper")
                  Trapper:wrap(function()
                        subscription = composer:testFeed(dialog)

                        if subscription
                        then
                           passed_test = true
                        end
                  end)
               end
            },
            {
               text = _("Save"),
               callback = function(touchmenu_instance)
                  local Trapper = require("ui/trapper")
                  Trapper:wrap(function()
                        if not passed_test
                        then
                           Trapper:info(GazetteMessages.CONFIGURE_SUBSCRIPTION_FEED_NOT_TESTED)
                        else
                           subscription:save()
                           UIManager:close(dialog)
                        end
                  end)
               end
            },
         },
      },
   }
   return dialog
end

return EditDialog
