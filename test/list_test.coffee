vows = require("vows")
assert = require("assert")
zombie = require("zombie")
webdriverjs = require("webdriverjs")
app = require("../app")

port = 3003
baseUrl = "http://localhost:#{port}"

# Start server for test.
app.start port

vows.describe("a sample vow")
  .addBatch
    "access top page":
      topic: () ->
        browser = new zombie.Browser({ debug: false })
        browser.runScripts = true
        browser.visit(baseUrl, this.callback)

      'Can see link to list' : (err, browser, status) ->
        assert.equal(status, 200)
        link = browser.link('ファイル一覧')
        assert.notEqual(link, null)

        browser.clickLink 'ファイル一覧', (e, browser, status) ->
          assert.equal(status, 200)

    # 'ファイル一覧'
    "access list page":
      topic: () ->
        browser = new zombie.Browser({ debug: false })
        browser.runScripts = true
        browser.visit(baseUrl + "/files", this.callback)

      'Can see link to upload' : (err, browser, status) ->
        link = browser.link('新規アップロード')
        assert.notEqual(link, null)

        browser.clickLink '新規アップロード', (e, browser, status) ->
          assert.equal(status, 200)

    # 'ファイルアップロード'
    "access upload page":
      topic: () ->
        browser = new zombie.Browser({ debug: false })
        browser.runScripts = true
        browser.visit(baseUrl + "/files/upload", this.callback)

      'Can see link to form' : (err, browser, status) ->
        client = webdriverjs.remote();
        client
        .init()
        .url baseUrl + "/upload", (res) ->
          console.log "--------- #{res} -------"
        .setValue("#file", "./spec/alice.epub")
        .click("#submit")
        .end()

    # '目次'
    "access files":
      topic: () ->
        browser = new zombie.Browser({ debug: false })
        browser.runScripts = true
        browser.visit(baseUrl + "/files", this.callback)

      'Can see link to toc' : (err, browser, status) ->
        link = browser.link('目次')
        assert.notEqual(link, null)
        browser.clickLink '目次', (e, browser, status) ->
          assert.equal(status, 200)
          link = browser.link('一覧へ')
          assert.notEqual(link, null)

        browser.visit(baseUrl + "/files?name=211949.epub", this.callback)

    # '閲覧'
    "access files":
       topic: () ->
        browser = new zombie.Browser({ debug: false })
        browser.runScripts = true
        browser.visit(baseUrl + "/files", this.callback)

      # 'Can see link to contents' : (err, browser, status) ->
      #  link = browser.link('閲覧')
      #  assert.notEqual(link, null)
      #  browser.clickLink '閲覧', (e, browser, status) ->
      #    assert.equal(status, 200)

      #  browser.visit(baseUrl + "/unziped/files/211949.epub", this.callback)

    # 'epub3 チェック'
    "access files":
      topic: () ->
        browser = new zombie.Browser({ debug: false })
        browser.runScripts = true
        browser.visit(baseUrl + "/files", this.callback)

      'Can see link to epubcheck' : (err, browser, status) ->
        link = browser.link('epub3 チェック')
        assert.notEqual(link, null)
        browser.clickLink 'epub3 チェック', (e, browser, status) ->
        assert.equal(status, 200)
.export module
