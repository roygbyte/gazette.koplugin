local Feed = require("feed/feed")
local RssFeed = require("feed/rss/rssfeed")
local AtomFeed = require("feed/atom/atomfeed")

local FeedFactory = {

}

function FeedFactory:make(url)
    local feed = Feed:new{
        url = url
    }
    feed:fetch()

    if is_atom(feed.xml) then
        return AtomFeed:new(feed)
    elseif is_rss(feed.xml) then
        return RssFeed:new(feed)
    elseif is_rdf(feed.xml) then
        -- Eventually add this
    end
end

function is_rss(document)
    return document.rss and
        document.rss.channel and
        document.rss.channel.title and
        document.rss.channel.item and
        document.rss.channel.item[1] and
        document.rss.channel.item[1].title and
        document.rss.channel.item[1].link
end

function is_atom(document)
    return document.feed and
        document.feed.title and
        document.feed.entry[1] and
        document.feed.entry[1].title and
        document.feed.entry[1].link
end

function is_rdf(document)
    return document["rdf:RDF"] and
        document["rdf:RDF"].channel and
        document["rdf:RDF"].channel.title
end

return FeedFactory
