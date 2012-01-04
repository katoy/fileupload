epub3 = require './src/epub3'
util = require 'util'

file_base = "spec/cc-katokt.epub"

epub3_info = (new epub3()).parse(file_base)

util.log util.inspect(epub3_info.container)
util.log util.inspect(epub3_info.opf)
util.log util.inspect(epub3_info.ncx)

