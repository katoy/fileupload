# ファイル操作
#
{spawn, exec} = require 'child_process'
fs = require 'fs'
fstream = require 'fstream'
util = require 'util'
mkdirp = require 'mkdirp'
path = require 'path'
wrench = require 'wrench'
epub3 = require './epub3'
Books = require "./books"
wget = require "./wget"
exec = require('child_process').exec

base_path = path.normalize("#{__dirname}/..")
uploaded_path = "#{__dirname}/../public/uploaded/files/"
uploaded_url = "/uploaded/files/"

books = new Books()

is_epub = (name) ->
  return false if (!name)
  ans = name.match('\.epub$')
  return ans && ans[0] == '.epub'

# module.exports.list = (callback) ->
  #fs.readdir uploaded_path, (err, files) ->
  #  ret_files = []
  #
  #  if files
  #    files.forEach (file) ->
  #      attr = {path: "#{uploaded_url}#{file}", name: file}
  #      if is_epub(file)
  #        try
  #          info = (new epub3()).parseSync(path.normalize("#{uploaded_path}#{file}"))
  #          attr.info = info
  #        catch err
  #          util.log err
  #
  #      ret_files.push attr
  #
  #  callback err, ret_files

module.exports.list = (callback) ->
  # callback(err, ans)

  books.findAll {}, (err, bs) ->
    ans = []
    ans.push info for info in bs
    console.log "-------- list-----------"
    console.log util.inspect(bs, false, null)
    callback(err, ans) if callback

module.exports.meta = (name, callback) ->
  # callback(err, info)
  file_path = path.normalize("#{uploaded_path}#{name}")

  books.findAll {where: {file: file_path}}, (err, bs) ->
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
      # util.log("----------- info.opf_dir=" + info.opf_dir)
    catch err
      util.log err

  callback(null, info)

local_to_lib = (f_path, f_name, callback) ->
  # callbacj(err, dest)

  # util.log "local_to_lib:" + fs.existsSync(f_path) + ", " + fs.statSync(f_path).size
  unless fs.existsSync(f_path)
    callback("file is not exist", f_path)
  else if fs.statSync(f_path).size == 0
    callback("file is empty.", f_path)
  else
    lib_path = path.normalize("#{uploaded_path}#{f_name}")
    fs.rename f_path, lib_path, (err) ->
      if err
        util.log "-- Error Rename #{f_path} - > #{lib_path}: err=" + err
        callback(err, f_path)
      else
        util.log "-- Rename #{f_path} - > #{lib_path}"

        # epub なら 解凍もする。
        if is_epub(f_name)
          books.addInfo lib_path, (new epub3()).parseSync(lib_path)
          unzip(f_name)

        callback(null, f_path)

module.exports.upload = (file, callback) ->
  # callback(err, dest)
  f_name = path.basename file['name']
  f_path = file['path']
  local_to_lib(f_path, f_name, callback)

module.exports.upload_url = (url, callback) ->
  # callback(err, dest)
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
      wrench.rmdirSyncRecursive  unziped_dir
      util.log "-- Delete dir #{unziped_dir}"

  callback(null)

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
  zip_file = "#{uploaded_path}#{file_name}"

  mkdirp.sync(unziped_path) unless fs.existsSync(unziped_path)

  if path.extname(file_name) == ".epub"
    util.log "unzipping: #{zip_file}"

    # run "unzip #{zip_file} #"{unziped_path}"
    exec "unzip #{zip_file} -d #{unziped_path}", (error, stdout, stderr) ->
      if (stdout != '')
        console.log '---------stdout: ---------\n' + stdout
      if (stderr != '')
        console.log '---------stderr: ---------\n' + stderr
      if (error != null)
        console.log '---------exec error: ---------\n' + error
