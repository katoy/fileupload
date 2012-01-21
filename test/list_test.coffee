vows = require("vows")
assert = require("assert")
zombie = require("zombie")
app = require("..//app")

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

    "access list page":
      topic: () ->
        browser = new zombie.Browser({ debug: false })
        browser.runScripts = true
        browser.visit(baseUrl + "/files", this.callback)

      'Can see link to list' : (err, browser, status) ->
        assert.equal(status, 200)

.export module
