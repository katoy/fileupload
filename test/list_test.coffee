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
      browser.visit(baseUrl, @callback)

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
      browser.visit(baseUrl + "/files", @callback)

    'Can see link to upload' : (err, browser, status) ->
      assert.equal(status, 200)
      link = browser.link('新規アップロード')
      assert.notEqual(link, null)

      browser.clickLink '新規アップロード', (e, browser, status) ->
        assert.equal(status, 200)

  # 'ファイルアップロード'
  "access upload page":
    topic: () ->
      browser = new zombie.Browser({ debug: false })
      browser.runScripts = true
      browser.visit(baseUrl + "/files/upload", @callback)

    'Can see link to form' : (err, browser, status) ->
      assert.equal(status, 200)
      client = webdriverjs.remote()
      client
      .init()
      .url baseUrl + "/upload", (res) ->
        console.log "--------- #{res} -------"
      .setValue("#file", "./spec/alice.epub")
      .click("#submit")
      .end()

  # 'ファイル一覧'
  "access files":
    topic: () ->
      browser = new zombie.Browser({ debug: false })
      browser.runScripts = true
      browser.visit(baseUrl + "/files", @callback)

    'Can see link to toc' : (err, browser, status) ->
      assert.equal(status, 200)
      link = browser.link('目次')
      assert.notEqual(link, null)
      browser.clickLink '目次', (e, browser, status) ->
        assert.equal(status, 200)
        link = browser.link('一覧へ')
        assert.notEqual(link, null)
        browser.clickLink '一覧へ', (e, browser, status) ->
          assert.equal(status, 200)
          # assert.equal(browser.location, "")

        link = browser.link('Direcoty 閲覧')
        assert.notEqual(link, null)
        browser.clickLink 'Direcoty 閲覧', (e, browser, status) ->
          assert.equal(status, 200)
          # assert.equal(browser.location, "")

  # '目次'
  "access toc":
    topic: () ->
      browser = new zombie.Browser({ debug: false })
      browser.runScripts = true
      browser.visit(baseUrl + "/toc?name=211949.epub", @callback)

    'Can see link to contents' : (err, browser, status) ->
      assert.equal(status, 200)
      link = browser.link('▶')
      assert.notEqual(link, null)
      link = browser.link('Direcoty 閲覧')
      assert.notEqual(link, null)
      link = browser.link('源氏物語 桐壺')
      assert.notEqual(link, null)

.export module
