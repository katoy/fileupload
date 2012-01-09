# epub3 のテスト

Epub3 = require '../src/epub3'
util = require 'util'


describe 'no-exist-file', ->

  beforeEach ->
    @epub3 = new Epub3()

describe 'alice', ->

  beforeEach ->
    @epub3 = new Epub3()
    @info = @epub3.parseSync './spec/alice.epub'

  # ==========================
  it 'container', ->
    expect(@info.container.opf_file).toEqual('19033/content.opf')

  # ==========================
  it 'opf.package', ->
    expect(@info.opf.package).toEqual({ version: '2.0', 'unique-identifier': 'id' })

  it 'opf.dc', ->
    expect(@info.opf.dc.identifier).toEqual('http://www.gutenberg.org/ebooks/19033')
    expect(@info.opf.dc.title).toEqual('Alice\'s Adventures in Wonderland')
    expect(@info.opf.dc.language).toEqual('en')
    expect(@info.opf.dc.contributor).toEqual('Gordon Robinson')
    expect(@info.opf.dc.coverage).toEqual(null)
    expect(@info.opf.dc.creator).toEqual('Lewis Carroll')
    expect(@info.opf.dc.date).toEqual('2006-08-12')
    expect(@info.opf.dc.description).toEqual(null)
    expect(@info.opf.dc.format).toEqual(null)
    expect(@info.opf.dc.publisher).toEqual(null)
    expect(@info.opf.dc.rights).toEqual('Public domain in the USA.')
    expect(@info.opf.dc.source).toEqual('http://www.gutenberg.org/files/19033/19033-h/19033-h.htm')
    expect(@info.opf.dc.type).toEqual(null)

    expect(@info.opf.dc.subject).toEqual('Fantasy')
    expect(@info.opf.dc.relation).toEqual(null)


  #  meta
  it 'opf.meta', ->
    expect(@info.opf.meta.length).toEqual(1)
    expect(@info.opf.meta[0]).toEqual({ content: 'item32', name: 'cover' } )

  #  link
  it 'opf.link', ->
    expect(@info.opf.link).toEqual([])

  #  manifest
  it 'opf.manifest', ->
    expect(@info.opf.manifest).toEqual({})

  #   item
  it 'opf.item', ->
    expect(@info.opf.item.length).toEqual(33)
    expect(@info.opf.item[0]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@cover_th.jpg', id: 'item1', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[1]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@title.jpg', id: 'item2', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[2]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@plate01_th.jpg', id: 'item3', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[3]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i001_th.jpg', id: 'item4', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[4]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i002_th.jpg', id: 'item5', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[5]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i003_th.jpg', id: 'item6', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[6]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i004_th.jpg', id: 'item7', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[7]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i005_th.jpg', id: 'item8', 'media-type': 'image/jpeg' },)
    expect(@info.opf.item[8]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i006_th.jpg', id: 'item9', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[9]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@plate02_th.jpg', id: 'item10', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[10]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i007_th.jpg', id: 'item11', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[11]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i008_th.jpg', id: 'item12', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[12]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i009_th.jpg', id: 'item13', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[13]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i010_th.jpg', id: 'item14', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[14]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i011_th.jpg', id: 'item15', 'media-type': 'image/jpeg' },)
    expect(@info.opf.item[15]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i012_th.jpg', id: 'item16', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[16]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@plate03_th.jpg', id: 'item17', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[17]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i013_th.jpg', id: 'item18', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[18]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i014_th.jpg', id: 'item19', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[19]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i015_th.jpg', id: 'item20', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[20]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i016_th.jpg', id: 'item21', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[21]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i017_th.jpg', id: 'item22', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[22]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@plate04_th.jpg', id: 'item23', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[23]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i018_th.jpg', id: 'item24', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[24]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i019_th.jpg', id: 'item25', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[25]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i020_th.jpg', id: 'item26', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[26]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i021_th.jpg', id: 'item27', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[27]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@images@i022_th.jpg', id: 'item28', 'media-type': 'image/jpeg' })
    expect(@info.opf.item[28]).toEqual({ href: 'pgepub.css', id: 'item29', 'media-type': 'text/css' })
    expect(@info.opf.item[29]).toEqual({ href: '0.css', id: 'item30', 'media-type': 'text/css' })
    expect(@info.opf.item[30]).toEqual({ href: '1.css', id: 'item31', 'media-type': 'text/css' })
    expect(@info.opf.item[31]).toEqual({ href: 'www.gutenberg.org@files@19033@19033-h@19033-h-0.htm', id: 'item32', 'media-type': 'application/xhtml+xml' })
    expect(@info.opf.item[32]).toEqual({ href: 'toc.ncx', id: 'ncx', 'media-type': 'application/x-dtbncx+xml' })

  #   spine
  it 'opf.spine', ->
    expect(@info.opf.spine).toEqual({ toc: 'ncx' })

  #   itemref
  it 'opf.itemref', ->
    expect(@info.opf.itemref.length).toEqual(1)
    expect(@info.opf.itemref[0]).toEqual({ idref: 'item32', linear: 'yes' })

  #   reference
  it 'opf.reference', ->
    expect(@info.opf.reference).toEqual([{ href: 'www.gutenberg.org@files@19033@19033-h@images@cover_th.jpg', type: 'cover', title: 'Cover Image' } ])

  #   bindings
  it 'opf.bindings', ->
    expect(@info.opf.bindings).toEqual({})

  #   mediatype
  it 'opf.mediatype', ->
    expect(@info.opf.mediatype).toEqual([])

  #   ncx_file
  it 'opf.ncx_file', ->
    expect(@info.opf.ncx_file).toEqual('toc.ncx')

  # ==========================
  #   ncx
  #   ncx meta
  it 'ncx.meta', ->
    expect(@info.ncx.meta.length).toEqual(5)
    expect(@info.ncx.meta[0]).toEqual({ content: 'http://www.gutenberg.org/ebooks/19033', name: 'dtb:uid' })
    expect(@info.ncx.meta[1]).toEqual({ content: '3', name: 'dtb:depth' })
    expect(@info.ncx.meta[2]).toEqual({ content: 'Project Gutenberg EPUB-Maker v0.02 by Marcello Perathoner <webmaster@gutenberg.org>', name: 'dtb:generator' })
    expect(@info.ncx.meta[3]).toEqual({ content: '0', name: 'dtb:totalPageCount' })
    expect(@info.ncx.meta[4]).toEqual({ content: '0', name: 'dtb:maxPageNumber' } )

  #   ncx docTitle
  it 'ncx.docTitle', ->
    expect(@info.ncx.docTitle).toEqual('Alice\'s Adventures in Wonderland')

  #   ncx navPoint
  it 'ncx.navpoint', ->
    expect(@info.ncx.navPoint.length).toEqual(14)
    expect(@info.ncx.navPoint[0]).toEqual({ id: 'np-1', playOrder: '1', text: 'THE "STORYLAND" SERIES', content: 'www.gutenberg.org@files@19033@19033-h@19033-h-0.htm#pgepubid00000', level: 1 },)
    expect(@info.ncx.navPoint[1]).toEqual({ id: 'np-2', playOrder: '3', text: 'ALICE\'S ADVENTURES IN WONDERLAND', content: 'www.gutenberg.org@files@19033@19033-h@19033-h-0.htm#pgepubid00002', level: 1 })
    expect(@info.ncx.navPoint[2]).toEqual({ id: 'np-3', playOrder: '5', text: 'SAM\'L GABRIEL SONS & COMPANY NEW YORK', content: 'www.gutenberg.org@files@19033@19033-h@19033-h-0.htm#pgepubid00004', level: 2 })
    expect(@info.ncx.navPoint[3]).toEqual({ id: 'np-4', playOrder: '7', text: 'Copyright, 1916, by SAM\'L GABRIEL SONS & COMPANY NEW YORK', content: 'www.gutenberg.org@files@19033@19033-h@19033-h-0.htm#pgepubid00006', level: 3 })
    expect(@info.ncx.navPoint[4]).toEqual({ id: 'np-5', playOrder: '8', text: 'I—DOWN THE RABBIT-HOLE',content: 'www.gutenberg.org@files@19033@19033-h@19033-h-0.htm#pgepubid00007', level: 2 })
    expect(@info.ncx.navPoint[5]).toEqual({ id: 'np-6', playOrder: '15', text: 'II—THE POOL OF TEARS', content: 'www.gutenberg.org@files@19033@19033-h@19033-h-0.htm#pgepubid00014', level: 2 })
    expect(@info.ncx.navPoint[6]).toEqual({ id: 'np-7', playOrder: '21', text: 'III—A CAUCUS-RACE AND A LONG TALE',content: 'www.gutenberg.org@files@19033@19033-h@19033-h-0.htm#pgepubid00020', level: 2 })
    expect(@info.ncx.navPoint[7]).toEqual({ id: 'np-8', playOrder: '28', text: 'IV—THE RABBIT SENDS IN A LITTLE BILL',content: 'www.gutenberg.org@files@19033@19033-h@19033-h-0.htm#pgepubid00027', level: 2 })
    expect(@info.ncx.navPoint[8]).toEqual({ id: 'np-9', playOrder: '35', text: 'V—ADVICE FROM A CATERPILLAR',content: 'www.gutenberg.org@files@19033@19033-h@19033-h-0.htm#pgepubid00034', level: 2 })
    expect(@info.ncx.navPoint[9]).toEqual({ id: 'np-10', playOrder: '41', text: 'VI—PIG AND PEPPER',content: 'www.gutenberg.org@files@19033@19033-h@19033-h-0.htm#pgepubid00040', level: 2 })
    expect(@info.ncx.navPoint[10]).toEqual({ id: 'np-11', playOrder: '46', text: 'VII—A MAD TEA-PARTY',content: 'www.gutenberg.org@files@19033@19033-h@19033-h-0.htm#pgepubid00045', level: 2 })
    expect(@info.ncx.navPoint[11]).toEqual({ id: 'np-12', playOrder: '49', text: 'VIII—THE QUEEN\'S CROQUET GROUND',content: 'www.gutenberg.org@files@19033@19033-h@19033-h-0.htm#pgepubid00048', level: 2 })
    expect(@info.ncx.navPoint[12]).toEqual({ id: 'np-13', playOrder: '55', text: 'IX—WHO STOLE THE TARTS?',content: 'www.gutenberg.org@files@19033@19033-h@19033-h-0.htm#pgepubid00054', level: 2})
    expect(@info.ncx.navPoint[13]).toEqual({ id: 'np-14', playOrder: '59', text: 'X—ALICE\'S EVIDENCE',content: 'www.gutenberg.org@files@19033@19033-h@19033-h-0.htm#pgepubid00058', level: 2 })


  # ==========================
  it 'get_content OK', ->
    @epub3.get_content 'www.gutenberg.org@files@19033@19033-h@19033-h-0.htm#pgepubid00000', (err, data) ->
      expect(err).toEqual(null)
      expect(data.substr(0,38)).toEqual("<?xml version='1.0' encoding='UTF-8'?>")
      jasmine.asyncSpecDone()

    jasmine.asyncSpecWait()

  it 'get_content NG', ->
    try
      @epub3.get_content 'Text/no-exist.xhtml', (err, data) ->
    catch err
      expect(err).toEqual("zip has not 19033/Text/no-exist.xhtml")

#--- End of File ---
