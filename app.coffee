# See
#   https://gist.github.com/893110
#   http://nodetuts.com/tutorials/12-file-uploads-using-nodejs-and-express.html

express = require 'express'
form = require 'connect-form'
fs = require 'fs'
util = require 'util'
#logger = require 'express-logger'
logger = express.logger

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

  app.use logger({path: './logs/log.txt',format: ':remote-addr - [:date] :method :url HTTP/:http-version :status :res[content-length] - :response-time ms'})

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
  app.use express.logger()

app.configure 'production', ->
  app.use express.errorHandler()
  app.use express.logger()

app.get '/', routes.index

app.get '/files', (req, res) ->

  files.list (err, file_list) ->
    res.render 'files/index', locals: files: file_list, title: 'Express'

app.get '/toc', (req, res) ->
  files.toc req.query['name'], (err, info) ->
    res.render 'files/toc', locals: info: info, title: 'Express'

get_parent = (toc, level) ->
  p = toc[0]
  i = 1
  while( i < level)
    len = p.child.length
    p = p.child[len - 1]
    i += 1
    null

  return p

app.get '/toc.json', (req, res) ->
  files.toc req.query['name'], (err, info) ->
    res.contentType('application/json');

    toc = [ {label:"root", child: []} ]
    for nav in info.ncx.navPoint
      node = { label: nav.text, href: nav.content, id: nav.id, child: []}
      level = nav.level
      parent = get_parent(toc, level)
      parent.child.push(node)

    data = JSON.stringify(toc);
    console.log(data)
    res.send(data);

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

module.exports.start = (port) ->
  app.listen port
  console.log "Express server listening on port #{port} in #{app.settings.env} mode"
  console.log "        See logs/log.txt"
