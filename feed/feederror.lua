local _ = require("gettext")
local T = require("ffi/util").template

local FeedError = {

}

FeedError.RESPONSE_NONSPECIFIC_ERROR = _("There was an error. That's all I know.")
FeedError.REQUEST_INCOMPLETE = _("Request couldn't complete. Code %1.")
FeedError.REQUEST_PAGE_NOT_FOUND = _("Page not found.")
FeedError.RESPONSE_NOT_XML = _("Feed is not an XML document.")
FeedError.RESPONSE_HAS_NO_CONTENT = _("No content found in response.")
FeedError.FEED_HAS_NO_CONTENT = _("The feed didn't return any content.")
FeedError.FEED_NONSPECIFIC_ERROR = _("There was an error. That's all I know.")
FeedError.FEED_NOT_SUPPORTED_SYNDICATION_FORMAT = _("URL is not a supported syndication format.")

function FeedError:provideFromResponse(response)
    if not response:hasCompleted()
    then
        return T(FeedError.REQUEST_INCOMPLETE, response.code)
    elseif response.code == 404 or not response:isHostKnown()
    then
        return FeedError.REQUEST_PAGE_NOT_FOUND
    elseif not response:isXml()
    then
        return FeedError.RESPONSE_NOT_XML
    elseif not response:hasContent()
    then
        return FeedError.RESPONSE_HAS_NO_CONTENT
    end
    return FeedError.RESPONSE_NONSPECIFIC_ERROR
end

function FeedError:provideFromFeed(feed)
    if feed.xml == nil
    then
        return FeedError.FEED_HAS_NO_CONTENT
    end
    return FeedError.FEED_NONSPECIFIC_ERROR
end

return FeedError
