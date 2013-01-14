
path = require 'path'
util = require 'util'

Epub3 = require './src/epub3'
Books = require './src/books'

books = new Books (errs, db) ->

  file = path.normalize './spec/kusamakura.epub'
  info = (new Epub3()).parseSync(file)

  console.log util.inspect(file)
  # console.log util.inspect(info)

  books.addInfo file, info, (err, book) ->
    # console.log "Book:  " + util.inspect(book)
    console.log ""
    console.log "# Added epub '#{book.file}' to '#{books.db.options.storage}'"
