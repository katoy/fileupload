fs = require("fs")
util = require 'util'

uploaded_path = __dirname + "/../public/uploaded/files/"
uploaded_url = "/uploaded/files/"

module.exports.list = (callback) ->
  util.log "files.list: uploaded_path=[#{uploaded_path}]"
  fs.readdir uploaded_path, (err, files) ->
    ret_files = []

    if files
      files.forEach (file) ->
        ret_files.push {path: "#{uploaded_url}#{file}", name: file}

    util.log "files.list: ret_file=" + ret_files
    callback err, ret_files

module.exports.upload = (file, callback) ->
  new_path = "#{uploaded_path}#{file['name']}"
  fs.rename file['path'], new_path, (data, error) ->
    throw error if error
    util.log "-- Rename #{file['path']} - > #{new_path}"

  callback()

module.exports.remove = (name, callback) ->
  path = "#{uploaded_path}#{name}"
  fs.unlinkSync path
  util.log "-- Delete #{path}"
  callback()
