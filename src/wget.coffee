
request = require 'request'
url = require 'url'
path = require 'path'
fs = require 'fs'
wrench = require 'wrench'

wget = (urlStr, dest_folder, dest_name, callback) ->

  urlPath = url.parse(urlStr).pathname
  dest_name ?= path.basename(urlPath)
  dest_name = "index.html" if dest_name == ""

  dest_folder = '.' if dest_folder == null or dest_folder == ""
  dest = path.join(dest_folder, dest_name)

  wrench.mkdirSyncRecursive(dest_folder, 0o0755) unless path.existsSync(dest_folder)

  request urlStr, (err, res, body) ->
    callback(err, dest)
  .pipe(fs.createWriteStream(dest))

module.exports.wget = wget

# wget 'http://www.google.com/', './tmp', null, (err, dest) ->
#   console.log "err="+ err
#   console.log "dest=" + dest
#
# wget 'https://raw.github.com/katoy/fileupload/master/README.md', './tmp', null, (err, dest) ->
#   console.log "err="+ err
#   console.log "dest=" + dest
#
# wget 'https://raw.github.com/katoy/fileupload/master/README.md', './tmp', '1.txt', (err, dest) ->
#   console.log "err="+ err
#   console.log "dest=" + dest
#
# wget 'https://raw.github.com/katoy/fileupload/master/README.md--zzz', './tmp', '2.txt', (err, dest) ->
#   console.log "err="+ err
#   console.log "out=" + dest

# wget 'http://i.wook.jp/000211/211672/211672.epub', './tmp', '2.txt', (err, dest) ->
#   console.log "err="+ err
#   console.log "out=" + dest
