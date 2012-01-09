# See
#   https://gist.github.com/893110
#   http://nodetuts.com/tutorials/12-file-uploads-using-nodejs-and-express.html

express = require 'express'
form = require 'connect-form'
fs = require 'fs'
util = require 'util'
argv = process.argv.slice(2)

files = require './src/files'

routes = require './routes'

app = module.exports = express.createServer(form {keepExtensions: true})

# switch between development and production like this:
# NODE_ENV=development coffee app.coffee
# OR
# NODE_ENV=production coffee app.coffee

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()

  app.use require('stylus').middleware(src: __dirname + '/public')
  app.use app.router
  app.use express.static(__dirname + '/public')

  app.use express.directory(__dirname + '/public')

app.configure 'development', ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure 'production', ->
  app.use express.errorHandler()

app.get '/', routes.index

app.get '/files', (req, res) ->
  files.list (err, file_list) ->
    res.render 'files/index', locals: files: file_list, title: 'Express'

app.get '/toc', (req, res) ->
  files.toc req.query['name'], (err, info) ->
    res.render 'files/toc', locals: info: info, title: 'Express'

app.get '/files/upload', (req, res) ->
  res.render 'files/upload', locals: title: 'Express'

app.post '/upload', (req, res) ->
  files.upload req.files.file, ->
    res.redirect '/files'

app.get '/delete', (req, res) ->
  files.remove req.query['name'], ->
    res.redirect '/files'

app.get '/epubcheck3', (req, res) ->
  res.setHeader('Content-Type', 'text/plain')
  files.epubcheck3 req.query['name'], req, res

app.get '/unzip', (req, res) ->
  res.setHeader('Content-Type', 'text/plain')
  files.unzip req.query['name']

port = argv[0] || process.env.PORT || 3000
app.listen port
console.log "Express server listening on port #{app.address().port} in #{app.settings.env} mode"

