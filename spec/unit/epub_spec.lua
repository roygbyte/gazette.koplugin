describe("Epub", function()
        local EpubFactory
        local xhtml_example_content
        setup(function()
                orig_path = package.path
                package.path = "plugins/gazette.koplugin/?.lua;" .. package.path
                require("commonrequire")
                EpubFactory = require("libs/epub/epubfactory")
                EpubError = require("libs/epub/epuberror")
                FeedFactory = require("feed/feedfactory")
                XHtmlItem = require("libs/epub/item/xhtmlitem")

                local ExampleContent = require("spec/unit/examplecontent")
                xhtml_example_content = ExampleContent.XHTML_EXAMPLE_CONTENT
        end)
        describe("Manifest", function()
                it("should build from a list of items", function()
                        local item_one = XHtmlItem:new{
                            path = "random/path/to/content.xhtml"
                        }
                        local item_two = XHtmlItem:new{
                            path = "another_random/path/to/content.xhtml"
                        }
                        local Manifest = require("libs/epub/package/manifest")
                        local manifest = Manifest:new{}
                        manifest:addItem(item_one)
                        manifest:addItem(item_two)
                        local nav = manifest.items[manifest:findItemLocationByProperties("nav")]
                        local expected_xml = string.format(
                            [[%s%s%s%s%s%s%s]],
                            "\n",
                            nav:getManifestPart(),
                            "\n",
                            item_one:getManifestPart(),
                            "\n",
                            item_two:getManifestPart(),
                            "\n"
                        )
                        assert.are.same(expected_xml, manifest:build())
                end)
                it("should not add the same item twice", function()
                        local item = XHtmlItem:new{
                            path = "random/path/to/content.xhtml"
                        }
                        local Manifest = require("libs/epub/package/manifest")
                        local manifest = Manifest:new{}
                        manifest:addItem(item)
                        manifest:addItem(item)
                        local nav = manifest.items[manifest:findItemLocationByProperties("nav")]
                        local expected_xml = string.format(
                            [[%s%s%s%s%s]],
                            "\n",
                            nav:getManifestPart(),
                            "\n",
                            item:getManifestPart(),
                            "\n"
                        )
                        assert.are.same(expected_xml, manifest:build())
                end)
        end)
        describe("XHtmlItem", function()
                it("should output manifest part", function()
                        local xhtml_content = XHtmlItem:new{
                            path = "random/path/to/content.xhtml",
                            content = xhtml_example_content
                        }
                        local manifest = xhtml_content:getManifestPart()
                        local manifest_to_match = string.format(
                            [[<item id="%s" href="%s" media-type="%s"/>]],
                            xhtml_content.id,
                            xhtml_content.path,
                            "application/xhtml+xml"
                        )
                        assert.are.same(manifest_to_match, manifest)
                end)
                it("should show error message when path isn't set", function()
                        local xhtml_content, err = XHtmlItem:new{}
                        assert.are.same(false, xhtml_content)
                        assert.are.same(EpubError.ITEM_MISSING_PATH, err)
                end)
        end)
        describe("EpubFactory", function()
                it("should create a new EpubWriter when given valid path", function()
                        local epubwriter, err = EpubFactory:makeWriter(
                            "/home/scarlett/00_test_epub.epub"
                        )
                        assert.are_not.same(false, epubwriter)
                end)
                it("should throw an error when creating EpubWriter with invalid path", function()
                        local epubwriter, err = EpubFactory:makeWriter(
                            "/home/scarlett/not_a_directory/00_test_epub.epub"
                        )
                        assert.are.same(false, epubwriter)
                        assert.are.same(EpubError.EPUBWRITER_INVALID_PATH, err)
                end)
                it("should build epub", function()
                        local item = XHtmlItem:new{
                            path = "content_1.xhtml",
                            content = xhtml_example_content
                        }
                        local epub = EpubFactory:makeEpub()
                        epub:addItem(item)

                        local epubWriter, err = EpubFactory:makeWriter(
                            "/home/scarlett/01_test_epub.epub"
                        )
                        local ok, err = epubWriter:buildEpub(epub)

                        assert.are.same(ok, true)
                end)
        end)
end)
