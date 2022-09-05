--[[--
Syndicated feed Reader... and more!

@module koplugin.Gazette
--]]--

local UIManager = require("ui/uimanager")
local WidgetContainer = require("ui/widget/container/widgetcontainer")
local _ = require("gettext")

local ConfigureSubscription = require("composers/configure_subscription")
local ViewSubscriptions = require("composers/view_subscriptions")
local SyncSubscriptions = require("composers/sync_subscriptions")

local Gazette = WidgetContainer:new{
    name = "gazette",
}

function Gazette:init()
    self.ui.menu:registerToMainMenu(self)
end

function Gazette:addToMainMenu(menu_items)
    menu_items.gazette = {
        text = _("Gazette"),
        sorting_hint = "tools",
        sub_item_table_func = function()
           return self:getSubMenuItems()
        end,
    }
end

function Gazette:getSubMenuItems()
   return {
      {
         text = _("Sync"),
         callback = function()
            self:syncSubscriptions()
         end
      },
      {
         text = _("Manage subscriptions"),
         callback = function()
            self:viewSubscriptions()
         end
      },
      {
         text = _("Settings"),
         sub_item_table = self:getConfigureSubMenuItems()
      }
   }
end

function Gazette:getConfigureSubMenuItems()
   return {
      {
         text = _("Add Subscription"),
         callback = function()
            ConfigureSubscription:newFeed()
         end
      },
   }
end

function Gazette:syncSubscriptions()
   SyncSubscriptions:sync()
end

function Gazette:viewSubscriptions()
   ViewSubscriptions:list()
end

return Gazette
