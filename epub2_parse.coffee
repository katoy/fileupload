EPub = require 'epub'
util = require 'util'

epub = new EPub("public/uploaded/files/alice.epub", "/imagewebroot/", "/articlewebroot/")
epub.on "error", (err) ->
  util.log "ERROR\n-----"
  throw err

epub.on "end", (err) ->
  util.log "METADATA:"
  util.log util.inspect(epub.metadata)

  util.log "SPINE:"
  util.log util.inspect(epub.flow)

  util.log "TOC:"
  util.log util.inspect(epub.toc)

  epub.getChapter epub.spine.contents[0].id, (err, data) ->
    if err
      util.log err
      return
    util.log "FIRST CHAPTER:"
    util.log data.substr(0, 512) + "..."

  # epub.getImage "item1", (err, data, mimeType) ->
  #  util.log (err || data);
  #  util.log mimeType

epub.parse()
