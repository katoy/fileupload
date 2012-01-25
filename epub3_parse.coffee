epub3 = require './src/epub3'
util = require 'util'

# file_base = "./public/uploaded/files/cc-katokt.epub"
# file_base = "./public/uploaded/files/kusamakura.epub"
file_base = "./public/uploaded/files/alice.epub"
# file_base = "./public/uploaded/files/211949.epub"
# file_base = "./spec/README.zip"
# file_base = "./spec/README.zipXXXXX"

show_cont = (info, epub3) ->
  util.log "---------------- container ------"
  util.log util.inspect(info.container)
  util.log "---------------- opf ------"
  util.log util.inspect(info.opf)
  util.log "---------------- ncx ------"
  util.log util.inspect(info.ncx)
  util.log "---------------- epub ------"
  util.log util.inspect(info.epub)

  c_path = info.ncx.navPoint[0].content
  util.log c_path
  epub3.get_content c_path, (err, data) ->
    util.log '---------------- get content ------'
    # throw err if err
    if err
      console.log err
    else
      util.log data.substr(0, 512) if data

  util.log '---------------- get content_ids ------'
  util.log id for id in epub3.get_content_ids()

  util.log '---------------- get item_ids ------'
  util.log id for id in epub3.get_item_ids()


epub3 = new epub3()

# 同期処理
info = epub3.parseSync(file_base)
show_cont(info, epub3)

# 非同期処理
epub3.parse file_base, (err, data) ->
  throw err if err
  show_cont(data, epub3)
