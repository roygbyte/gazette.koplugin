describe("HTTP Utilities", function()
    setup(function()
        orig_path = package.path
        package.path = "plugins/gazette.koplugin/?.lua;" .. package.path
        require("commonrequire")
    end)
    describe("Request", function()
        it("should use default config values if RequestFactory passes empty config", function()
            local RequestFactory = require("libs/http/requestfactory")
            local Request = require("libs/http/request")

            local empty_config = {}
            local request = RequestFactory:makeGetRequest("https://koreader.rocks", empty_config)
            assert.are.same(Request.default.maxtime, request.maxtime)
            assert.are.same(Request.default.timeout, request.timeout)
            assert.are.same(Request.default.redirects, request.redirects)
        end)
        it("should use config values passed in argument", function()
            local RequestFactory = require("libs/http/requestfactory")
            local Request = require("libs/http/request")
            local different_config = {
              maxtime = 60,
              timeout = 20
            }
            local request = RequestFactory:makeGetRequest("https://koreader.rocks", different_config)
            assert.are.same(60, request.maxtime)
            assert.are.same(20, request.timeout)
        end)
    end)
    describe("RequestFactory", function()
        it("should create new requests", function()
            local RequestFactory = require("libs/http/requestfactory")
            local request_1 = RequestFactory:makeGetRequest("https://koreader.rocks", {})
            local request_2 = RequestFactory:makeGetRequest("https://google.com", {})
            assert.are.same("https://koreader.rocks", request_1.url)
        end)
    end)
    describe("Response", function()
        it("should return correct response codes", function()
            local RequestFactory = require("libs/http/requestfactory")

            local request = RequestFactory:makeGetRequest("https://koreader.rocks", {})
            local response = request:send()
            assert.are.same(200, response.code)

            local request = RequestFactory:makeGetRequest("https://koreader.sucks/", {})
            local response = request:send()
            assert.are.same(404, response.code)
        end)
        it("should return correct values from methods", function()
            local RequestFactory = require("libs/http/requestfactory")

            local request = RequestFactory:makeGetRequest("https://koreader.rocks", {})
            local response = request:send()
            assert.are.same(true, response:hasCompleted())
            assert.are.same(true, response:hasHeaders())
            assert.are.same(true, response:canBeConsumed())
        end)
        it("should have correct url after redirect", function()
            local RequestFactory = require("libs/http/requestfactory")

            local request = RequestFactory:makeGetRequest("https://scarlettmcallister.com/test_redirect.php", {})
            local response = request:send()
            assert.are.same("https://koreader.rocks", response.url)
        end)
        it("should decode XML documents", function()
            local RequestFactory = require("libs/http/requestfactory")

            local request = RequestFactory:makeGetRequest("https://scarlettmcallister.com/rss.xml", {})
            local response = request:send()
            assert.are.same(true, response:canBeConsumed())
            assert.are.same(true, response:hasContent())
            assert.are.same("table", type(response.content))
        end)
        it("should not contain content from another response", function()
            local RequestFactory = require("libs/http/requestfactory")

            local request_1 = RequestFactory:makeGetRequest("https://scarlettmcallister.com/rss.xml", {})
            local response_1 = request_1:send()
            local request_2 = RequestFactory:makeGetRequest("https://ourworldindata.org/atom.xml", {})
            local response_2 = request_2:send()

            assert.are_not.same(response_2.headers.server, response_1.headers.server)
        end)
        it("should work for files, too?", function()
                --https://thenewleafjournal.com/feed
                -- Downloads a file with feed info...
        end)
    end)
end)
