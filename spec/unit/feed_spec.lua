
describe("Feed", function()
        local FeedFactory
        setup(function()
                orig_path = package.path
                package.path = "plugins/gazette.koplugin/?.lua;" .. package.path
                require("commonrequire")
                FeedFactory = require("feed/feedfactory")
                FeedError = require("feed/feederror")
        end)
        describe("FeedFactory", function()
                it("should return different values for different objects", function()
                        local feed_1 = FeedFactory:make("https://scarlettmcallister.com/rss.xml")
                        local feed_2 = FeedFactory:make("https://ourworldindata.org/atom.xml")
                        assert.are_not.same(feed_1.url, feed_2.url)
                end)
        end)
        describe("AtomFeed", function()
                it("should have correct channel information", function()
                        local feed = FeedFactory:make("https://ourworldindata.org/atom.xml")
                        assert.are.same("Our World in Data", feed.title)
                        assert.are.same("Research and data to make progress against the world’s largest problems", feed.subtitle)
                end)
                it("should be valid", function()
                        local feed = FeedFactory:make("https://ourworldindata.org/atom.xml")
                        assert.are.same(true, feed:isValid())
                end)
        end)
        describe("RssFeed", function()
                it("should have correct channel information", function()
                        local feed = FeedFactory:make("https://scarlettmcallister.com/rss.xml")
                        assert.are.same("(Scarlett's Dooryard)", feed.title)
                        assert.are.same("Emacs 27.2 Org-mode 9.4.4", feed.generator)
                end)
                it("should be valid", function()
                        local feed = FeedFactory:make("https://scarlettmcallister.com/rss.xml")
                        assert.are.same(true, feed:isValid())
                end)
        end)
        describe("FeedError", function()
                it("should display correct error message when feed URL doesn't exist", function()
                        local feed, err = FeedFactory:make("https://koreader.sucks")
                        assert.are.same(FeedError.REQUEST_PAGE_NOT_FOUND, err)
                        assert.are.same(feed, false)
                end)
                it("should display correct error message when feed URL isn't a XML document", function()
                        local feed, err = FeedFactory:make("https://koreader.rocks")
                        assert.are.same(FeedError.RESPONSE_NOT_XML, err)
                        assert.are.same(feed, false)
                end)
                it("should display error messages when URL is not a supported syndication format", function()
                        local feed, err = FeedFactory:make("https://scarlettmcallister.com/nocontent.xml")
                        assert.are.same(FeedError.FEED_NOT_SUPPORTED_SYNDICATION_FORMAT, err)
                        assert.are.same(feed, false)
                end)
        end)
        describe("Feed", function()
                it("should return values we want regardless of whether it's Atom or Rss", function()
                        local feed_1 = FeedFactory:make("https://scarlettmcallister.com/rss.xml")
                        local feed_2 = FeedFactory:make("https://ourworldindata.org/atom.xml")
                        assert.are.same("Research and data to make progress against the world’s largest problems", feed_2:getDescription())
                        assert.are.same("https://ourworldindata.org/", feed_2:getPermalink())
                        assert.are.same("http://orgmode.org/img/org-mode-unicorn-logo.png", feed_1:getLogo())
                end)
        end)
        describe("Entry", function()
                it("should return values we want regardless of whether it's Atom or Rss", function()
                        local feed_rss = FeedFactory:make("https://scarlettmcallister.com/rss.xml")
                        local rss_entry = feed_rss.entries[1]
                        assert.is.truthy(rss_entry:getPermalink())
                        assert.is.truthy(rss_entry:getPublished())

                        local feed_atom = FeedFactory:make("https://ourworldindata.org/atom.xml")
                        local atom_entry = feed_atom.entries[1]
                        assert.is.truthy(atom_entry:getPermalink())
                        assert.is.truthy(atom_entry:getPublished())
                end)
                it("should fetch content", function()
                        local feed_rss = FeedFactory:make("https://scarlettmcallister.com/rss.xml")
                        local rss_entry = feed_rss.entries[1]
                        rss_entry:fetch()
                        assert.is.truthy(rss_entry.content)
                end)
                it("should display error when entry can't get fetched", function()
                        local feed_rss = FeedFactory:make("https://scarlettmcallister.com/rss.xml")
                        local rss_entry = feed_rss.entries[1]
                        rss_entry.link = "https://scarlettmcallister.com/entry-that-does-not-exist"
                        local ok, err = rss_entry:fetch()
                        assert.are.same(FeedError.REQUEST_PAGE_NOT_FOUND, err)
                end)
        end)
end)
