
Epub3 = require '../src/epub3'
util = require 'util'


describe 'no-exist-file', ->

  beforeEach ->
    @epub3 = new Epub3()

  it 'no-exist-file', ->
    try
      @info = @epub3.parseSync 'no-exist-file.epub'
      expect("01 true").toEqual("01 false")
    catch err
      expect("02 true").toEqual("02 true")

describe 'kusamakura', ->

  beforeEach ->
    @epub3 = new Epub3()
    @info = @epub3.parseSync './spec/kusamakura.epub'

  it 'epub3 kusamakura', ->
    # container
    expect(@info.container.opf_file).toEqual('OEBPS/package.opf')

    expect(@info.opf.package.version).toEqual('3.0')

    # opf
    #  dc
    expect(@info.opf.dc.identifier).toEqual('urn:uuid:eae22280-0019-43c1-b8cc-8d79bd7d9c36')
    expect(@info.opf.dc.title).toEqual('草枕')
    expect(@info.opf.dc.language).toEqual('ja')
    expect(@info.opf.dc.contributor).toEqual(null)
    expect(@info.opf.dc.coverage).toEqual(null)
    expect(@info.opf.dc.creator).toEqual('夏目 漱石',)
    expect(@info.opf.dc.date).toEqual(null)
    expect(@info.opf.dc.description).toEqual(null)
    expect(@info.opf.dc.format).toEqual(null)
    expect(@info.opf.dc.publisher).toEqual()
    expect(@info.opf.dc.rights).toEqual(null)
    expect(@info.opf.dc.source).toEqual(null)
    expect(@info.opf.dc.type).toEqual(null)

    #  meta

    #  link
    expect(@info.opf.manifexg).toEqual([])
    #  manifest
    expect(@info.opf.manifexg).toEqual([])
    #   item

    #   spine
    expect(@info.opf.spine).toEqual( { toc: 'ncx', 'page-progression-direction': 'rtl' })
    #   itemref
    #   reference
    expect(@info.opf.reference).toEqual([])
    #   bindings
    expect(@info.opf.bindings).toEqual({})
    #   mediatype
    expect(@info.opf.mediatype).toEqual([])
    #   ncx_file
    expect(@info.opf.ncx_file).toEqual('toc.ncx')
#--- End of File ---
