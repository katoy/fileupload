util = require 'util'
Books = require './src/books'

books = new Books (errs, db) ->
  console.log ""
  console.log "# ******* Success inited '#{db}'"

#######################
#  To delete DB
#  $ rm database.sql
#######################
#  $ sqlite3 database.sqlite
#  > .tables
#  > select * from books
#  > .quit
#