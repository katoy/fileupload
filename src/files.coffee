# ファイル操作
#
{spawn, exec} = require 'child_process'
fs = require 'fs'
util = require 'util'
zip = require 'zipfile'
path = require 'path'
wrench = require 'wrench'
epub3 = require './epub3'
wget = require "./wget"

uploaded_path = "#{__dirname}/../public/uploaded/files/"
uploaded_url = "/uploaded/files/"

is_epub = (name) ->
  return false if (!name)
  ans = name.match('\.epub$')
  return ans && ans[0] == '.epub'

module.exports.list = (callback) ->
  fs.readdir uploaded_path, (err, files) ->
    ret_files = []

    if files
      files.forEach (file) ->
        attr = {path: "#{uploaded_url}#{file}", name: file}
        if is_epub(file)
          try
            info = (new epub3()).parseSync("#{uploaded_path}#{file}")
            attr.info = info
          catch err
            util.log err

        ret_files.push attr

    callback err, ret_files

module.exports.toc = (name, callback) ->
  file_path = "#{uploaded_path}#{name}"
  info = {}
  if is_epub(name)
    try
      info = (new epub3()).parseSync("#{uploaded_path}#{name}")
      info.opf_dir = path.dirname(info.container.opf_file)
      # util.log("----------- info.opf_dir=" + info.opf_dir)
    catch err
      util.log err

  callback null, info


local_to_lib = (f_path, f_name, callback) ->

  # util.log "local_to_lib:" + fs.existsSync(f_path) + ", " + fs.statSync(f_path).size
  unless fs.existsSync(f_path)
    callback("file is not exist", f_path)
  else if fs.statSync(f_path).size == 0
    callback("file is empty.", f_path)
  else
    lib_path = "#{uploaded_path}#{f_name}"
    fs.rename f_path, lib_path, (err) ->
      if err
        util.log "-- Error Rename #{f_path} - > #{lib_path}: err=" + err
        callback(err)
      else
        util.log "-- Rename #{f_path} - > #{lib_path}"

        # epub なら 解凍もする。
        unzip(f_name) if is_epub(f_name)

        callback(null)

module.exports.upload = (file, callback) ->
  f_name = file['name']
  f_path = file['path']
  local_to_lib(f_path, f_name, callback)

module.exports.upload_url = (url, callback) ->
  wget.wget url, "./tmp", null, (err, dest) ->
    if err
      util.log "upload_url: err=" + err
      callback(err, dest)
    else
      util.log "Downloaded. " + dest
      f_name = path.basename(dest)
      local_to_lib dest, f_name, (err) ->
        callback(err, dest)

module.exports.remove = (name, callback) ->
  file_path = "#{uploaded_path}#{name}"
  if path.existsSync(file_path)
    fs.unlinkSync file_path
    util.log "-- Delete #{file_path}"

  # epub なら 解凍したファイルも削除する。
  if (is_epub(name))
    unziped_dir = "#{__dirname}/../public/unziped/files/#{name}"
    if path.existsSync(unziped_dir)
      wrench.rmdirSyncRecursive  unziped_dir
      util.log "-- Delete dir #{unziped_dir}"

  callback()

module.exports.epubcheck3 = (name, req, res) ->
  file_path = "./public/uploaded/files/#{name}"
  util.log "-- epubcheck3 #{file_path}"
  run res, "#{__dirname}/../public/uploaded/check3.sh '#{file_path}'"

module.exports.unzip = (name, req, res) ->
  unzip(name)

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

unzip = (file_name) ->
  unziped_path = "#{__dirname}/../public/unziped/files/#{file_name}"

  zf = new zip.ZipFile("#{uploaded_path}#{file_name}")
  zf.names.forEach (name) ->
    uncompressed = path.join(unziped_path, name)
    dirname = path.dirname(uncompressed)
    try
      util.log "------- mkdir #{dirname}"
      wrench.mkdirSyncRecursive(dirname, 0o0755)
    catch err
      throw err if (err and not err.code.match(/^EEXIST/))

    if path.extname(name)
      util.log "unzipping: #{name}"

      buffer = zf.readFileSync(name)
      fd = fs.openSync(uncompressed, 'w')
      fs.writeSync fd, buffer, 0, buffer.length, null
      fs.closeSync fd
