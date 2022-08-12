local DataStorage = require("datastorage")
local LuaSettings = require("frontend/luasettings")
local LuaData = require('luadata')

local data_storage_dir = "/home/scarlett" -- print(DataStorage:getSettingsDir())

local State = {
   id = nil,
   state_file = "news_config.lua",
   lua_settings = nil,
}

function State:new(o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o:init()
   return o
end

function State:init()
   self.lua_settings = LuaSettings:open(("%s/%s"):format(data_storage_dir, self.state_file))

   if not self.lua_settings
   then
      return false
   end
end

function State:load()
   local state = self.lua_settings:child(self.id)

   for key, value in pairs(state.data) do
      self[key] = value
   end
end

function State:save()
   if not self.id
   then
      self.id = self:generateUniqueId()
   end

   self.lua_settings:saveSetting(self.id, self)
   self.lua_settings:flush()
end

function State:generateUniqueId(maybe_id)
   maybe_id = maybe_id or 1
   local maybe_key = "subscription_" .. tostring(maybe_id)

   if not self.lua_settings:has(maybe_key)
   then
      return maybe_key
   end

   return self:generateUniqueId(maybe_id + 1)
end

function State:deleteConfig()
   os.remove(("%s/%s"):format(data_storage_dir, self.state_file))
end

return State
