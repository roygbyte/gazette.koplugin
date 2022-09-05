local util = require("frontend/util")

local EpubBuildDirector = require("libs/gazette/epubbuilddirector")
local WebPage = require("libs/gazette/resources/webpage")
local ResourceAdapter = require("libs/gazette/resources/webpageadapter")
local Epub = require("libs/gazette/epub/epub")

local SubscriptionBuilder = {

}

function SubscriptionBuilder:new(o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function SubscriptionBuilder:buildSingleEntry(subscription, entry)

   local builder = SubscriptionBuilder:new()

   local webpage, err = builder:createWebpage(entry)
   if not webpage
   then
      print(err)
      return false, err
   end

   local epub = Epub:new{}
   epub:addFromList(ResourceAdapter:new(webpage))
   epub:setTitle(
      entry:getTitle()
   )

   local output_dir = "/home/scarlett/"
   local epub_title = entry:getTitle()
   local epub_path = output_dir .. util.getSafeFilename(epub_title) .. ".epub"
   print(epub_path)
   print(subscription:getDownloadDirectory())
   local build_director, err = builder:createBuildDirector(epub_path)
   if not build_director
   then
      print(err)
      return false, err
   end

   local ok, err = build_director:construct(epub)

end

function SubscriptionBuilder:createWebpage(entry)
   local webpage, err = WebPage:new({
         url = entry:getPermalink()
   })

   if err
   then
      return false
   end

   local success, err = webpage:build()

   if err
   then
      return false, err
   end

   return webpage
end

function SubscriptionBuilder:createBuildDirector(epub_path)
   local build_director, err = EpubBuildDirector:new()

   if not build_director
   then
      return false, err
   end

   local success, err = build_director:setDestination(epub_path)

   if not success
   then
      return false, err
   end

   return build_director
end

return SubscriptionBuilder