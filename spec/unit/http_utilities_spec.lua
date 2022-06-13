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
      end)
end)
