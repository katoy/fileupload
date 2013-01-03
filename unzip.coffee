
# ファイル解凍するコマンドラインアプリケーション。

zip = require 'zipfile'
fs = require 'fs'
path = require 'path'
util = require 'util'
mkdirp = require 'mkdirp'

usage = 'usage: $ node unzip.js zipfile [out_dir]'

file = process.argv[2]
out_dir = '.'
out_dir = process.argv[3] if process.argv.length > 3

unless file
  console.log usage
  process.exit 1

zf = new zip.ZipFile(file)
zf.names.forEach (name) ->
  uncompressed = path.join(out_dir, name)
  dirname = path.dirname(uncompressed)
  mkdirp.mkdirp dirname, 0o0755, (err) ->
    throw err  if err and not err.code.match(/^EEXIST/)

    if path.extname(name)
      buffer = zf.readFileSync(name)
      fd = fs.openSync(uncompressed, 'w')
      util.log "unzipping: #{name}"
      fs.writeSync fd, buffer, 0, buffer.length, null
      fs.closeSync fd
