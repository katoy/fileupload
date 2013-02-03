# ファイル操作
#
{spawn, exec} = require 'child_process'
fs = require 'fs'
fstream = require 'fstream'
util = require 'util'
mkdirp = require 'mkdirp'
path = require 'path'
epub3 = require './epub3'
Books = require "./books"
wget = require "./wget"
exec = require('child_process').exec

base_path = path.normalize("#{__dirname}/..")
uploaded_path = "#{__dirname}/../public/uploaded/files/"
uploaded_url = "/uploaded/files/"

books = new Books()

is_epub = (name) ->
  return false unless name
  ans = name.match(/\.epub$/i)
  return ans && ans[0] == '.epub'

is_pdf = (name) ->
  return false unless name
  ans = name.match(/\.pdf$/i)
  return ans && ans[0] == '.pdf'

module.exports.list = (callback) ->
  # callback(err, ans)

  books.findAll {order: 'id DESC'}, (err, bs) ->
    ans = []
    ans.push info for info in bs
    util.log util.inspect(bs, false, null)
    callback(err, ans) if callback

module.exports.meta = (name, callback) ->
  # callback(err, info)
  file_path = path.normalize("#{uploaded_path}#{name}")

  books.findAll {where: {file: file_path}, order: 'id DESC'}, (err, bs) ->
    info = null
    info = attr for attr in bs
    callback(err, info) if callback

module.exports.toc = (name, callback) ->
  # callback(err, info)
  file_path = path.normalize("#{uploaded_path}#{name}")
  info = {}
  if is_epub(name)
    try
      info = (new epub3()).parseSync(path.normalize("#{uploaded_path}#{name}"))
      info.opf_dir = path.dirname(info.container.opf_file)
    catch err
      util.log "-- toc: err=#{err}"

  callback(null, info) if callback

local_to_lib = (f_path, f_name, callback) =>
  # callback(err, dest)

  unless fs.existsSync(f_path)
    return callback("file is not exist", f_path) if callback

  if fs.statSync(f_path).size == 0
    return callback("file is empty.", f_path) if callback

  lib_path = path.normalize("#{uploaded_path}#{f_name}")
  if fs.existsSync(lib_path)
    return callback("Already uploaded #{f_name}", f_path) if callback

  fs.rename f_path, lib_path, (err) =>
    if err
      util.log "-- Error Rename #{f_path} - > #{lib_path}: err=#{err}"
      fs.unlinkSync(lib_path)
      return callback(err, f_path) if callback
    else
      util.log "-- Rename #{f_path} - > #{lib_path}"
      try
        # epub なら 解凍もする。
        if is_epub(f_name)
          books.addInfo_epub lib_path, (new epub3()).parseSync(lib_path)

          unziped_path = "#{__dirname}/../public/unziped/files/#{f_name}"
          @unzip lib_path, unziped_path, null
          callback(null, f_path) if callback

        else if is_pdf(f_name)
          getPDFMetadata lib_path, (info) ->
            books.addInfo_pdf lib_path, info
          callback(null, f_path) if callback
  
      catch ex
        util.log "-- Error in loca_to_lib #{f_name}"
        fs.unlinkSync(lib_path)
        callback(ex, f_path) if callback

  getPDFMetadata = (path, callback) ->
    # callback(info)
    exec "ruby lib/pdfmetadata.rb #{path}", null, (error, stdout, stderr) ->
      console.log "---- getPDFMetadata stdout:" + stdout
      info = JSON.parse(stdout)
      callback(info)  if callback

module.exports.upload = (file, callback) ->
  # callback(err, dest)
  f_name = path.basename file['name']
  f_path = file['path']
  local_to_lib(f_path, f_name, callback)

module.exports.upload_url = (url, callback) ->
  # callback(err, dest)
  wget.wget url, "./tmp", null, (err, dest) ->
    if err
      util.log "-- upload_url: err=#{err}"
      callback(err, dest) if callback
    else
      util.log "Downloaded. " + dest
      f_name = path.basename(dest)
      local_to_lib dest, f_name, callback

module.exports.remove = (name, callback) ->
  # callback(err)
  file_path = path.normalize("#{uploaded_path}#{name}")

  books.del {where: {file: file_path}}, (err, num) ->
    if path.existsSync(file_path)
      fs.unlinkSync file_path
      util.log "-- Delete #{file_path}"

  # epub なら 解凍したファイルも削除する。
  if (is_epub(name))
    unziped_dir = "#{__dirname}/../public/unziped/files/#{name}"
    if path.existsSync(unziped_dir)
      @rmDirSyncRecursive unziped_dir
      util.log "-- Delete dir #{unziped_dir}"

  callback(null) if callback

module.exports.rmDirSyncRecursive = (dirPath) ->
  # fs.lchmodSync dirPath, 0o0700
  for f in fs.readdirSync(dirPath)
    filePath ="#{dirPath}/#{f}"

    # fs.lchmodSync filePath, 0o0700
    if fs.statSync(filePath).isFile()
      fs.unlinkSync filePath
    else
      @rmDirSyncRecursive filePath

  fs.rmdirSync dirPath

module.exports.unzip = (zip_file, unziped_path, callback) ->
  # callback(error, stdout, stderr)
  mkdirp.sync(unziped_path) unless fs.existsSync(unziped_path)

  if path.extname(zip_file) == ".epub"
    util.log "unzipping: #{zip_file}"

    # run "unzip #{zip_file} #"{unziped_path}"
    exec "unzip #{zip_file} -d #{unziped_path}", null, callback
  else
    callback(null, null, null) if callback

module.exports.epubcheck3 = (name, req, res) ->
  file_path = "./public/uploaded/files/#{name}"
  util.log "-- epubcheck3 #{file_path}"
  run res, "#{__dirname}/../public/uploaded/check3.sh '#{file_path}'"

run = (res, args...) ->
  str = ''
  for a in args
    switch typeof a
      when 'string' then command = a
      when 'object'
        if a instanceof Array then params = a
        else options = a
      when 'function' then callback = a

  command += ' ' + params.join ' ' if params?
  cmd = spawn '/bin/sh', ['-c', command], options
  res.write '--- Start Checking ---\n'
  util.log '--- Start Checking ---'

  cmd.stdout.on 'data', (data) ->
    res.write data
    util.log data
  cmd.stderr.on 'data', (data) ->
    res.write data
    util.log data
  cmd.on 'exit', (code) ->
    res.end '\n--- End Checking ---'
    util.log '--- End Checking ---'
  process.on 'SIGHUP', ->
    cmd.kill()
    res.end '\n--- End Checking ---'
    util.log '--- End Checking ---'
