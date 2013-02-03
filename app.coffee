# See
#   https://gist.github.com/893110
#   http://nodetuts.com/tutorials/12-file-uploads-using-nodejs-and-express.html

express = require 'express'
routes = require './routes'
http = require 'http'
path = require 'path'

fs = require 'fs'
util = require 'util'
#logger = require 'express-logger'
logger = express.logger

files = require './src/files'

# app = module.exports = express.createServer(form {keepExtensions: true})
app = module.exports = express()

# switch between development and production like this:
# NODE_ENV=development coffee app.coffee
# OR
# NODE_ENV=production coffee app.coffee

app.configure ->
  app.set 'port', (process.env.PORT or 3000)
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.favicon()

  app.use logger({path: './logs/log.txt',format: ':remote-addr - [:date] :method :url HTTP/:http-version :status :res[content-length] - :response-time ms'})

  app.use express.bodyParser()
  app.use express.methodOverride()

  app.use require('stylus').middleware(src: __dirname + '/public')
  app.use app.router
  app.use express.static(path.join(__dirname, 'public'))
  app.use express.directory(path.join(__dirname, 'public'), icons:true)

  app.use (req, res, next) ->
    res.status(404)
    res.render '404', {message: "お探しのページは存在しません。" + req.url}

app.configure 'development', ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )
  app.use express.logger()

app.configure 'production', ->
  app.use express.errorHandler()
  app.use express.logger()

app.locals title: 'Express eBook Reader', pretty: true

app.get '/help', (req, res) ->
    res.render 'help'

app.get '/', (req, res) ->
  res.redirect '/files'

app.get '/files', (req, res) ->

  files.list (err, file_list) ->
    res.render 'files/index', files: file_list

app.get '/toc', (req, res) ->
  files.toc req.query['name'], (err, info) ->
    chap = []
    pos2chap = []
    chap2pos = []

    if !info or !info.opf or !info.opf.itemref
      res.render 'err', {message: "epub3 解析エラー" + "<br/>" + req.url}
      return

    for v in info.opf.itemref
      idref = v.idref
      href = ""
      for p in info.opf.item
        if  p.id == idref
          href = p.href
          break
      chap.push href

    ch = 0
    if info.ncx and info.ncx.navPoint
      for v in info.ncx.navPoint
        cont = v.content
        idref = ""
        for item in info.opf.item
          idref = item.id  if item.href == cont
        for ref, idx in info.opf.itemref
          ch = idx if ref.idref == idref
        pos2chap.push ch

    pos = 0
    for v in info.opf.itemref
      idref = v.idref
      href = ""
      for item in info.opf.item
        href = item.href if item.id == idref
      if info.ncx and info.ncx.navPoint
        for p, idx in info.ncx.navPoint
          pos = idx if p.content == href
        chap2pos.push pos

    res.render 'files/toc', {info: info, chap: chap, pos2chap: pos2chap, chap2pos: chap2pos}

get_parent = (toc, level) ->
  p = toc[0]
  i = 1
  while( i < level)
    len = p.child.length
    p = p.child[len - 1]
    i += 1

  return p

app.get '/toc.json', (req, res) ->
  files.toc req.query['name'], (err, info) ->
    res.contentType('application/json')

    toc = [ {label:"root", child: []} ]
    if info.ncx and info.ncx.navPoint
      for nav in info.ncx.navPoint
        node = { label: nav.text, href: nav.content, id: nav.id, child: []}
        level = nav.level
        parent = get_parent(toc, level)
        parent.child.push(node)

    data = JSON.stringify(toc)
    util.log(data)
    res.send(data)

app.get '/files/upload', (req, res) ->
  res.render 'files/upload'

app.post '/upload', (req, res) ->
  files.upload req.files.file, (err, dest) ->
    util.log " start /upload #{dest}"
    if err
      res.render 'err', {message: err}
    else
      res.redirect '/files'

app.post '/upload/url', (req, res) ->
  url = req.param("q");
  files.upload_url url, (err, dest) ->
    util.log " start /upload #{dest}"
    if err
      res.render 'err', {message: err}
    else
      res.redirect '/files'

app.get '/delete', (req, res) ->
  files.remove req.query['name'], (err) ->
    res.redirect '/files'

app.get '/epubcheck3', (req, res) ->
  res.setHeader('Content-Type', 'text/plain')
  files.epubcheck3 req.query['name'], req, res

app.get '/unzip', (req, res) ->
  res.setHeader('Content-Type', 'text/plain')
  files.unzip req.query['name']

app.get '/meta/:name', (req, res) ->
  name = req.params.name
  files.meta name, (err, attr) ->
    util.log "--------- /meta/:name"
    util.log util.inspect(attr, false, null)
    res.contentType('text/plain')
    ans = "<center>" + name + "<table border='1'>"
    for key, val of attr.meta
      ans += "<tr><td align='right' style='padding:4px;'>" + key + "</td><td align='left' style='padding:4px;'>" + val + "</td></tr>"  if val
    ans += "</table></center>"
    res.send ans

module.exports.start = (port) ->
  http.createServer(app).listen port, ->
    util.log "        Express server listening on port #{port} in #{app.settings.env} mode"
    util.log "        See logs/log.txt"
