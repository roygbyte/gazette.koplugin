describe("EpubBuildDirector", function()
        local EpubBuildDirector
        local Epub

        local xhtml_example_content
        setup(function()
                orig_path = package.path
                package.path = "plugins/gazette.koplugin/?.lua;" .. package.path
                require("commonrequire")
                EpubBuildDirector = require("libs/gazette/epubbuilddirector")
                EpubError = require("libs/gazette/epuberror")
                Epub = require("libs/gazette/epub/epub")
                FeedFactory = require("feed/feedfactory")
                XHtmlItem = require("libs/gazette/epub/package/item/xhtmlitem")

                local ExampleContent = require("spec/unit/examplecontent")
                xhtml_example_content = ExampleContent.XHTML_EXAMPLE_CONTENT
        end)
        describe("EpubBuildDirector", function()
                it("should create a new EpubWriter when given valid path", function()
                        local build_director, err = EpubBuildDirector:new()
                        build_director:setDestination("/home/scarlett/00_test_epub.epub")
                        assert.are_not.same(false, build_director)
                end)
                it("should throw an error when creating EpubWriter with invalid path", function()
                        local build_director, err = EpubBuildDirector:new()
                        local ok, err = build_director:setDestination("/home/not_a_directory/00_test_epub.epub")
                        assert.are.same(false, ok)
                        assert.are.same(EpubError.EPUBWRITER_INVALID_PATH, err)
                end)
                it("should build epub", function()
                        local item = XHtmlItem:new{
                            path = "content_1.xhtml",
                            content = xhtml_example_content
                        }
                        local epub = Epub:new()
                        epub:addItem(item)

                        local build_director, err = EpubBuildDirector:new()
                        build_director:setDestination("/home/scarlett/00_test_epub.epub")
                        local ok, err = build_director:construct(epub)

                        assert.are.same(true, ok)
                end)
        end)
end)
