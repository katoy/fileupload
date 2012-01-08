# epub3 のテスト

Epub3 = require '../src/epub3'
util = require 'util'


describe 'no-exist-file', ->

  beforeEach ->
    @epub3 = new Epub3()

  it 'no-exist-file', ->
    # expect(@epub3.parseSync('no-exist-file.epub')).toThrow('file not found no-exist-file.epub')
    try
      @epub3.parseSync('no-exist-file.epub')
      expect(false).toEqual('file not found no-exist-file.epub')
    catch err
      expect(err).toEqual('file not found no-exist-file.epub')

  it 'bad-file', ->
    try
      @epub3.parseSync('spec/README.zip')
      expect(false).toEqual('bad-file')
    catch err
      expect(err).toEqual('No mimetype file in spec/README.zip')

describe 'kusamakura', ->

  beforeEach ->
    @epub3 = new Epub3()
    @info = @epub3.parseSync './spec/kusamakura.epub'

  # ==========================
  it 'container', ->
    expect(@info.container.opf_file).toEqual('OEBPS/package.opf')

  # ==========================
  it 'opf.dc', ->
    expect(@info.opf.package).toEqual({ 'unique-identifier': 'pub-id', lang: 'ja', version: '3.0' })

  it 'opf.dc', ->
    expect(@info.opf.dc.identifier).toEqual('urn:uuid:eae22280-0019-43c1-b8cc-8d79bd7d9c36')
    expect(@info.opf.dc.title).toEqual('草枕')
    expect(@info.opf.dc.language).toEqual('ja')
    expect(@info.opf.dc.contributor).toEqual(null)
    expect(@info.opf.dc.coverage).toEqual(null)
    expect(@info.opf.dc.creator).toEqual('夏目 漱石')
    expect(@info.opf.dc.date).toEqual(null)
    expect(@info.opf.dc.description).toEqual(null)
    expect(@info.opf.dc.format).toEqual(null)
    expect(@info.opf.dc.publisher).toEqual(null)
    expect(@info.opf.dc.rights).toEqual(null)
    expect(@info.opf.dc.source).toEqual(null)
    expect(@info.opf.dc.type).toEqual(null)

  #  meta
  it 'opf.meta', ->
    expect(@info.opf.meta.length).toEqual(5)
    expect(@info.opf.meta[0]).toEqual({ refines: '#title', property: 'title-type' })
    expect(@info.opf.meta[1]).toEqual({ refines: '#creator', property: 'role', scheme: 'marc:relators', id: 'role' })
    expect(@info.opf.meta[2]).toEqual({ property: 'dcterms:source-identifier' })
    expect(@info.opf.meta[3]).toEqual({ property: 'dcterms:publisher' })
    expect(@info.opf.meta[4]).toEqual({ property: 'dcterms:modified' })

  #  link
  it 'opf.link', ->
    expect(@info.opf.link).toEqual([])

  #  manifest
  it 'opf.manifest', ->
    expect(@info.opf.manifest).toEqual({})

  #   item
  it 'opf.item', ->
    expect(@info.opf.item.length).toEqual(27)
    expect(@info.opf.item[0]).toEqual({ id: 'ncx', href: 'toc.ncx', 'media-type': 'application/x-dtbncx+xml' })
    expect(@info.opf.item[1]).toEqual({ id: 'horizontal', href: 'Styles/horizontal.css','media-type': 'text/css' })
    expect(@info.opf.item[2]).toEqual({ id: 'vertical',   href: 'Styles/vertical.css', 'media-type': 'text/css' })
    expect(@info.opf.item[3]).toEqual({ id: 'cover_vertical', href: 'Styles/cover_vertical.css', 'media-type': 'text/css' })
    expect(@info.opf.item[4]).toEqual({ id: 'cover_horizontal', href: 'Styles/cover_horizontal.css', 'media-type': 'text/css' })
    expect(@info.opf.item[5]).toEqual({ id: 'title_vertical', href: 'Styles/title_vertical.css', 'media-type': 'text/css' })
    expect(@info.opf.item[6]).toEqual({ id: 'title_horizontal', href: 'Styles/title_horizontal.css', 'media-type': 'text/css' })
    expect(@info.opf.item[7]).toEqual({ id: 'nav',properties: 'nav', href: 'Text/navigation.xhtml', 'media-type': 'application/xhtml+xml' })
    expect(@info.opf.item[8]).toEqual({ id: 'cover_page', href: 'Text/cover.xhtml', 'media-type': 'application/xhtml+xml' })
    expect(@info.opf.item[9]).toEqual({ id: 'title_page', href: 'Text/titlepage.xhtml', 'media-type': 'application/xhtml+xml' })
    expect(@info.opf.item[10]).toEqual({ id: 'c01', href: 'Text/content001.xhtml', 'media-type': 'application/xhtml+xml' })
    expect(@info.opf.item[11]).toEqual({ id: 'c02', href: 'Text/content002.xhtml', 'media-type': 'application/xhtml+xml' })
    expect(@info.opf.item[12]).toEqual({ id: 'c03', href: 'Text/content003.xhtml', 'media-type': 'application/xhtml+xml' })
    expect(@info.opf.item[13]).toEqual({ id: 'c04', href: 'Text/content004.xhtml', 'media-type': 'application/xhtml+xml' })
    expect(@info.opf.item[14]).toEqual({ id: 'c05', href: 'Text/content005.xhtml','media-type': 'application/xhtml+xml' })
    expect(@info.opf.item[15]).toEqual({ id: 'c06', href: 'Text/content006.xhtml', 'media-type': 'application/xhtml+xml' })
    expect(@info.opf.item[16]).toEqual({ id: 'c07', href: 'Text/content007.xhtml', 'media-type': 'application/xhtml+xml' })
    expect(@info.opf.item[17]).toEqual({ id: 'c08', href: 'Text/content008.xhtml', 'media-type': 'application/xhtml+xml' })
    expect(@info.opf.item[18]).toEqual({ id: 'c09', href: 'Text/content009.xhtml', 'media-type': 'application/xhtml+xml' })
    expect(@info.opf.item[19]).toEqual({ id: 'c10', href: 'Text/content010.xhtml', 'media-type': 'application/xhtml+xml' })
    expect(@info.opf.item[20]).toEqual({ id: 'c11', href: 'Text/content011.xhtml', 'media-type': 'application/xhtml+xml' })
    expect(@info.opf.item[21]).toEqual({ id: 'c12', href: 'Text/content012.xhtml', 'media-type': 'application/xhtml+xml' })
    expect(@info.opf.item[22]).toEqual({ id: 'c13', href: 'Text/content013.xhtml', 'media-type': 'application/xhtml+xml' })
    expect(@info.opf.item[23]).toEqual({ id: 'notice', href: 'Text/notice.xhtml', 'media-type': 'application/xhtml+xml' })
    expect(@info.opf.item[24]).toEqual({ id: 'colophon_page', href: 'Text/colophon.xhtml', 'media-type': 'application/xhtml+xml' })
    expect(@info.opf.item[25]).toEqual({ id: 'cover', properties: 'cover-image', href: 'Images/cover.png', 'media-type': 'image/png' })
    expect(@info.opf.item[26]).toEqual({ id: 'author_portrait', href: 'Images/author_portrait.jpg', 'media-type': 'image/jpeg' })

  #   spine
  it 'opf.spine', ->
    expect(@info.opf.spine).toEqual( { toc: 'ncx', 'page-progression-direction': 'rtl' })

  #   itemref
  it 'opf.itemref', ->
    expect(@info.opf.itemref.length).toEqual(18)
    expect(@info.opf.itemref[0]).toEqual({ idref: 'cover_page', linear: 'yes' })
    expect(@info.opf.itemref[1]).toEqual({ idref: 'title_page', linear: 'yes' })
    expect(@info.opf.itemref[2]).toEqual({ idref: 'nav', linear: 'yes' },)
    expect(@info.opf.itemref[3]).toEqual({ idref: 'c01', linear: 'yes' })
    expect(@info.opf.itemref[4]).toEqual({ idref: 'c02', linear: 'yes' })
    expect(@info.opf.itemref[5]).toEqual({ idref: 'c03', linear: 'yes' })
    expect(@info.opf.itemref[6]).toEqual({ idref: 'c04', linear: 'yes' })
    expect(@info.opf.itemref[7]).toEqual({ idref: 'c05', linear: 'yes' })
    expect(@info.opf.itemref[8]).toEqual({ idref: 'c06', linear: 'yes' })
    expect(@info.opf.itemref[9]).toEqual({ idref: 'c07', linear: 'yes' },)
    expect(@info.opf.itemref[10]).toEqual({ idref: 'c08', linear: 'yes' },)
    expect(@info.opf.itemref[11]).toEqual({ idref: 'c09', linear: 'yes' })
    expect(@info.opf.itemref[12]).toEqual({ idref: 'c10', linear: 'yes' })
    expect(@info.opf.itemref[13]).toEqual({ idref: 'c11', linear: 'yes' })
    expect(@info.opf.itemref[14]).toEqual({ idref: 'c12', linear: 'yes' })
    expect(@info.opf.itemref[15]).toEqual({ idref: 'c13', linear: 'yes' },)
    expect(@info.opf.itemref[16]).toEqual({ idref: 'notice', linear: 'yes' })
    expect(@info.opf.itemref[17]).toEqual({ idref: 'colophon_page', linear: 'yes' } )

  #   reference
  it 'opf.reference', ->
    expect(@info.opf.reference).toEqual([])

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
    expect(@info.ncx.meta.length).toEqual(4)
    expect(@info.ncx.meta[0]).toEqual({ name: 'dtb:uid', content: 'eae22280-0019-43c1-b8cc-8d79bd7d9c36' })
    expect(@info.ncx.meta[1]).toEqual({ name: 'dtb:depth', content: '1' })
    expect(@info.ncx.meta[2]).toEqual({ name: 'dtb:totalPageCount', content: '0' },)
    expect(@info.ncx.meta[3]).toEqual({ name: 'dtb:maxPageNumber', content: '0' } )

  #   ncx docTitle
  it 'ncx.docTitle', ->
    expect(@info.ncx.docTitle).toEqual('')

  #   ncx navPoint
  it 'ncx.navpoint', ->
    expect(@info.ncx.navPoint.length).toEqual(18)
    expect(@info.ncx.navPoint[0]).toEqual({ id: 'cover_page', playOrder: '1', text: '草枕', content: 'Text/cover.xhtml' })
    expect(@info.ncx.navPoint[1]).toEqual({ id: 'title_page', playOrder: '2', text: 'タイトル',content: 'Text/titlepage.xhtml' })
    expect(@info.ncx.navPoint[2]).toEqual({ id: 'nav',        playOrder: '3', text: '目次', content: 'Text/navigation.xhtml' })
    expect(@info.ncx.navPoint[3]).toEqual({ id: 'content001', playOrder: '4', text: '一', content: 'Text/content001.xhtml' })
    expect(@info.ncx.navPoint[4]).toEqual({ id: 'content002', playOrder: '5', text: '二', content: 'Text/content002.xhtml' })
    expect(@info.ncx.navPoint[5]).toEqual({ id: 'content003', playOrder: '6', text: '三', content: 'Text/content003.xhtml' })
    expect(@info.ncx.navPoint[6]).toEqual({ id: 'content004', playOrder: '7', text: '四', content: 'Text/content004.xhtml' })
    expect(@info.ncx.navPoint[7]).toEqual({ id: 'content005', playOrder: '8', text: '五', content: 'Text/content005.xhtml' })
    expect(@info.ncx.navPoint[8]).toEqual({ id: 'content006', playOrder: '9', text: '六', content: 'Text/content006.xhtml' })
    expect(@info.ncx.navPoint[9]).toEqual({ id: 'content007', playOrder: '10', text: '七', content: 'Text/content007.xhtml' })
    expect(@info.ncx.navPoint[10]).toEqual({ id: 'content008',playOrder: '11', text: '八', content: 'Text/content008.xhtml' })
    expect(@info.ncx.navPoint[11]).toEqual({ id: 'content009',playOrder: '12', text: '九', content: 'Text/content009.xhtml' })
    expect(@info.ncx.navPoint[12]).toEqual({ id: 'content010',playOrder: '13', text: '十', content: 'Text/content010.xhtml' })
    expect(@info.ncx.navPoint[13]).toEqual({ id: 'content011',playOrder: '14', text: '十一', content: 'Text/content011.xhtml' })
    expect(@info.ncx.navPoint[14]).toEqual({ id: 'content012',playOrder: '15', text: '十二', content: 'Text/content012.xhtml' })
    expect(@info.ncx.navPoint[15]).toEqual({ id: 'content013',playOrder: '16', text: '十三', content: 'Text/content013.xhtml' })
    expect(@info.ncx.navPoint[16]).toEqual({ id: 'notice',    playOrder: '17', text: 'この本について', content: 'Text/notice.xhtml' })
    expect(@info.ncx.navPoint[17]).toEqual({ id: 'colophon_page', playOrder: '18', text: '奥付', content: 'Text/colophon.xhtml' } )

#--- End of File ---
