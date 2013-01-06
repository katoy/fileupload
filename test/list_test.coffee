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
      browser.waitFor = 3000
      browser.visit(baseUrl, @callback)

    'Can see link to list' : (err, browser, status) ->
      assert.equal(status, 200)
      link = browser.link('一覧')
      assert.notEqual(link, null)
      browser.clickLink '一覧', (e, browser, status) ->
        assert.equal(status, 200)
        assert.equal(browser.location, "/files")
        browser.back ->

    'Can see link to upload' : (err, browser, status) ->
      link = browser.link('登録')
      assert.notEqual(link, null)
      browser.clickLink '登録', (e, browser, status) ->
        assert.equal(status, 200)
        assert.equal(browser.location, "files/upload")
        browser.back ->

    'Can see link to help' : (err, browser, status) ->
      link = browser.link('ヘルプ')
      assert.notEqual(link, null)
      browser.clickLink 'ヘルプ', (e, browser, status) ->
        assert.equal(status, 200)
        assert.equal(browser.location, "/help")
        browser.back  ->

  # '一覧' のページ
  "access list page":
    topic: () ->
      browser = new zombie.Browser({ debug: false })
      browser.runScripts = true
      browser.waitFor = 3000
      browser.visit(baseUrl + "/files", @callback)

    'Can see link to upload' : (err, browser, status) ->
      assert.equal(status, 200)
      link = browser.link('登録')
      assert.notEqual(link, null)

      browser.clickLink '登録', (e, browser, status) ->
        assert.equal(status, 200)

  # '登録' のページ
  "access upload page":
    topic: () ->
      browser = new zombie.Browser({ debug: false })
      browser.runScripts = true
      browser.waitFor = 3000
      browser.visit(baseUrl + "/files/upload", @callback)

    'Can see link to form' : (err, browser, status) ->
      assert.equal(status, 200)
#      client = webdriverjs.remote()
#      client
#      .init()
#      .url(baseUrl + "/files/upload")
#      .waitFor("#file", 5000)
#      .setValue("#file", "./spec/alice.epub")
#      .submitForm("#submit")
#      .saveScreenshot "1.png", (result) ->
#        console.log "*********************************************** " + result
#      .end()

  # '一覧'
  "access files":
    topic: () ->
      browser = new zombie.Browser({ debug: false })
      browser.runScripts = true
      browser.waitFor = 3000
      browser.visit(baseUrl + "/files", @callback)

    'Can see link to toc' : (err, browser, status) ->
      assert.equal(status, 200)
      link = browser.link('草枕')
      assert.notEqual(link, null)
      browser.clickLink '草枕', (e, browser, status) ->
        assert.equal(status, 200)
        assert.equal(browser.location, baseUrl + "/toc?name=kusamakura.epub")

  # '目次'
  "access toc":
    topic: () ->
      browser = new zombie.Browser({ debug: false })
      browser.runScripts = true
      browser.waitFor = 3000

      browser.visit(baseUrl + "/toc?name=kusamakura.epub", @callback)

    'Can see link to contents' : (err, browser, status) ->
      assert.equal(status, 200)

      link = browser.link('#unzipped_files')
      assert.notEqual(link, null)

      link = browser.link('草枕')
      assert.notEqual(link, null)

.export module
