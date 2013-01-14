
# ファイル解凍するコマンドラインアプリケーション。

unzip = require 'unzip'
fs = require 'fs'
fstream = require 'fstream'
mkdirp = require 'mkdirp'

usage = 'usage: $ coffee unzip.coffee zipfile [out_dir]'

file = null
file = process.argv[2] if process.argv.length > 2
out_dir = '.'
out_dir = process.argv[3] if process.argv.length > 3

if file is null
  console.log usage
  process.exit 1

unless fs.existsSync(file)
  console.log "No exists: #{file}"
  process.exit 1

mkdirp.sync(out_dir) unless fs.existsSync(out_dir)

readStream = fs.createReadStream(file)
writeStream = fstream.Writer(out_dir)

readStream.pipe(unzip.Parse()).pipe writeStream
