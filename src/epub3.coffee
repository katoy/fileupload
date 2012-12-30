zipfile = require "zipfile"
libxmljs = require 'libxmljs'
assert = require 'assert'
fs = require 'fs'
path = require 'path'
util = require 'util'


get_text =  (node) ->
  return node if !node
  node.text()

merge_hash = (h1, h2) ->
  ans = {}

  ans[name] = h1[name] for name of h1
  ans[name] = h2[name] for name of h2

  ans

class Epub3

  checkMimetype: (callback) ->
    hasMimetype = false
    for f in @zf.names
      if f.toLowerCase() == 'mimetype'
        hasMimetype = true
        @zf.readFile f, (err, data) ->
          throw err if err
          mimetype = data.toString("utf-8").toLowerCase().trim()
          throw new Error("illegal mimetype: #{mimetype}") if mimetype != 'application/epub+zip'
          callback(err, mimetype) if callback

    throw new Error("No mimetype file in #{@epub_path}") if !hasMimetype

  checkMimetypeSync:  ->
    hasMimetype = false
    for f in @zf.names
      if f.toLowerCase() == 'mimetype'
        hasMimetype = true
        @zf.readFile f, (err, data) ->
          throw err if err
          mimetype = data.toString("utf-8").toLowerCase().trim()
          throw new Error("illegal mimetype: #{mimetype}") if mimetype != 'application/epub+zip'

    throw new Error("No mimetype file in #{@epub_path}") if !hasMimetype
    true

  parse_container:  ->
    data = @zf.readFileSync('META-INF/container.xml')
    doc = libxmljs.parseXmlString(data.toString('utf-8'))
    # util.log doc.toString()

    rootfiles = doc.get("//xmlns:rootfiles", 'urn:oasis:names:tc:opendocument:xmlns:container')
    throw new Error(" 'META-INF/container.xml has no rootfiles") if !rootfiles

    rootfile = doc.get("//xmlns:rootfiles/xmlns:rootfile", 'urn:oasis:names:tc:opendocument:xmlns:container')
    throw new Error(" 'META-INF/container.xml has no rootfiles/rootfile") if !rootfile

    mediatype = rootfile.attr('media-type').value()
    throw new Error(" 'META-INF/container.xml rootfile is not 'application/oebps-package+xml'") if mediatype != 'application/oebps-package+xml'

    opf_file = rootfile.attr('full-path').value()
    throw new Error(" 'META-INF/container.xml has no 'full-path'") if !opf_file

    container = {}
    container.opf_file = opf_file.trim()
    # console.log container
    container

  parse_opf: (opf_file) ->
    opf = {}
    opf.package_info = {}

    data = @zf.readFileSync opf_file
    doc = libxmljs.parseXmlString(data.toString('utf-8'))
    # util.log doc.toString()

    # See
    # - http://idpf.org/epub/30/spec/epub30-publications.html#sec-package-def

    @namespaces_opf =  {xmlns: 'http://www.idpf.org/2007/opf', dc: "http://purl.org/dc/elements/1.1/"}

    # package
    package_ = doc.get("//xmlns:package", @namespaces_opf)
    opf.package_info[a.name()] = a.value() for a in package_.attrs()

    opf = merge_hash(opf, this.parse_opf3(doc)) if opf.package_info.version == "3.0"
    opf = merge_hash(opf, this.parse_opf2(doc))  if opf.package_info.version == "2.0"

    opf

  parse_opf3: (doc) ->
    # console.log "------------ parse_opf3 -------------"
    opf = {}
    opf.dc = {}
    opf.meta = []
    opf.link = []
    opf.manifest = {}
    opf.item = []
    opf.spine = {}
    opf.itemref = []
    opf.reference = []
    opf.bindings = {}
    opf.mediatype = []

    # meta:
    # dc
    dc_identifier  = get_text doc.get("//dc:identifier", @namespaces_opf)
    dc_title       = get_text doc.get("//dc:title", @namespaces_opf)
    dc_language    = get_text doc.get("//dc:language", @namespaces_opf)
    dc_creator     = get_text doc.get("//dc:creator", @namespaces_opf)

    dc_contributor = get_text doc.get("//dc:contributor", @namespaces_opf)
    dc_coverage    = get_text doc.get("//dc:coverage", @namespaces_opf)
    dc_creator     = get_text doc.get("//dc:creator", @namespaces_opf)
    dc_date        = get_text doc.get("//dc:date", @namespaces_opf)
    dc_description = get_text doc.get("//dc:description", @namespaces_opf)
    dc_format      = get_text doc.get("//dc:format", @namespaces_opf)
    dc_publisher   = get_text doc.get("//dc:publisher", @namespaces_opf)
    dc_relation    = get_text doc.get("//dc:relation", @namespaces_opf)
    dc_rights      = get_text doc.get("//dc:rights", @namespaces_opf)
    dc_source      = get_text doc.get("//dc:source", @namespaces_opf)
    dc_subject     = get_text doc.get("//dc:subject", @namespaces_opf)
    dc_type        = get_text doc.get("//dc:type", @namespaces_opf)

    opf.dc = {
      identifier:  dc_identifier,
      title:       dc_title,
      language:    dc_language,

      contributor: dc_contributor,
      coverage:    dc_coverage,
      creator:     dc_creator,
      date:        dc_date,
      description: dc_description,
      format:      dc_format,
      publisher:   dc_publisher,
      relation:    dc_relation,
      rights:      dc_rights,
      source:      dc_source,
      subject:     dc_subject,
      type:        dc_type
    }

    # meta
    metas = doc.find("//xmlns:meta", @namespaces_opf)

    for m in metas
      h = {}
      h[a.name()] = a.value() for a in m.attrs()
      opf.meta.push(h)

    # link
    links = doc.find("//xmlns:link", @namespaces_opf)

    for link in links
      h = {}
      h[a.name()] = a.value() for a in link.attrs()
      opf.link.push(h)

    # manifest
    manifest = doc.get("//xmlns:manifest", @namespaces_opf)
    opf.spine[a.name()] = a.value() for a in manifest.attrs()

    # item
    items = doc.find("//xmlns:item", @namespaces_opf)
    for item in items
      h = {}
      for a in item.attrs()
        k = a.name()
        v = a.value()
        h[a.name()] = v
        opf.ncx_file = "#{item.attr('href').value()}" if (v == 'ncx') && (k == 'id')

      opf.item.push(h)

    # spine
    spine = doc.get("//xmlns:spine", @namespaces_opf)
    for a in spine.attrs()
      opf.spine[a.name()] = a.value()

    # itemref
    itemrefs = doc.find("//xmlns:itemref", @namespaces_opf)
    for itemref in itemrefs
      h = {}
      h[a.name()] = a.value() for a in itemref.attrs()
      opf.itemref.push(h)

    # guide
    # reference
    refs = doc.find("//xmlns:reference", @namespaces_opf)
    for ref in refs
      h = {}
      h[a.name()] = a.value() for a in ref.attrs()
      opf.reference.push(h)

    # bindings
    # mediaType
    mts = doc.find("//xmlns:mediaType", @namespaces_opf)
    for mt in mts
      h = {}
      h[a.name()] = a.value() for a in mt.attrs()
      opf.mediatype.push(h)

    opf

  parse_opf2: (doc) ->
    # console.log "------------ parse_opf2 -------------"
    opf = {}
    opf.dc = {}
    opf.meta = []
    opf.link = []
    opf.manifest = {}
    opf.item = []
    opf.spine = {}
    opf.itemref = []
    opf.reference = []
    opf.bindings = {}
    opf.mediatype = []

    # meta:
    # dc
    dc_title       = get_text doc.get("//dc:title", @namespaces_opf)
    dc_creator     = get_text doc.get("//dc:creator", @namespaces_opf)
    dc_subject     = get_text doc.get("//dc:subject", @namespaces_opf)
    dc_description = get_text doc.get("//dc:description", @namespaces_opf)
    dc_publisher   = get_text doc.get("//dc:publisher", @namespaces_opf)
    dc_contributor = get_text doc.get("//dc:contributor", @namespaces_opf)
    dc_date        = get_text doc.get("//dc:date", @namespaces_opf)
    dc_type        = get_text doc.get("//dc:type", @namespaces_opf)
    dc_format      = get_text doc.get("//dc:format", @namespaces_opf)
    dc_identifier  = get_text doc.get("//dc:identifier", @namespaces_opf)
    dc_source      = get_text doc.get("//dc:source", @namespaces_opf)
    dc_language    = get_text doc.get("//dc:language", @namespaces_opf)
    dc_relation    = get_text doc.get("//dc:relation", @namespaces_opf)
    dc_coverage    = get_text doc.get("//dc:coverage", @namespaces_opf)
    dc_rights      = get_text doc.get("//dc:rights", @namespaces_opf)

    opf.dc = {
      title:       dc_title,
      creator:     dc_creator,
      subject:     dc_subject,
      description: dc_description,
      publisher:   dc_publisher,
      contributor: dc_contributor,
      date:        dc_date,
      type:        dc_type
      format:      dc_format,
      identifier:  dc_identifier,
      source:      dc_source,
      language:    dc_language,
      relation:    dc_relation,
      coverage:    dc_coverage,
      rights:      dc_rights,
    }

    # meta
    metas = doc.find("//xmlns:meta", @namespaces_opf)
    metas = doc.find("//meta") if metas.length == 0
    for m in metas
      h = {}
      h[a.name()] = a.value() for a in m.attrs()
      opf.meta.push(h)

    # manifest
    manifest = doc.get("//xmlns:manifest", @namespaces_opf)
    opf.spine[a.name()] = a.value() for a in manifest.attrs()

    # item
    items = doc.find("//xmlns:item", @namespaces_opf)
    items = doc.find("//item") if items.length == 0
    for item in items
      h = {}
      for a in item.attrs()
        k = a.name()
        v = a.value()
        h[a.name()] = v
        opf.ncx_file = "#{item.attr('href').value()}" if (v == 'ncx') && (k == 'id')
        opf.ncx_file = "#{item.attr('href').value()}" if (v == 'ncxtoc') && (k == 'id')

      opf.item.push(h)

    # spine
    spine = doc.get("//xmlns:spine", @namespaces_opf)
    spine = doc.get("//spine") if spine.length == 0
    opf.spine[a.name()] = a.value() for a in spine.attrs()

    # itemref
    itemrefs = doc.find("//xmlns:itemref", @namespaces_opf)
    itemrefs = doc.find("//itemref") if itemrefs.length == 0
    for itemref in itemrefs
      h = {}
      h[a.name()] = a.value() for a in itemref.attrs()
      opf.itemref.push(h)

    # guide
    # reference
    refs = doc.find("//xmlns:reference", @namespaces_opf)
    refs = doc.find("//reference") if refs.length == 0
    for ref in refs
      h = {}
      h[a.name()] = a.value() for a in ref.attrs()
      opf.reference.push(h)

    opf

  parse_ncx : (ncx_file) ->

    data = @zf.readFileSync ncx_file
    doc = libxmljs.parseXmlString(data.toString('utf-8'))
    # util.log "--------- parse_ncx -------"
    # util.log doc.toString()

    ncx = {}
    ncx.meta = []
    ncx.docTitle = ""
    ncx.navPoint = []   # id, playorder, label content

    @namespaces_ncx =  {xmlns: 'http://www.daisy.org/z3986/2005/ncx/'}

    # meta
    metas = doc.find("//xmlns:meta", @namespaces_ncx)
    metas = doc.find("//meta") if metas.length == 0
    for m in metas
      h = {}
      h[a.name()] = a.value() for a in m.attrs()
      ncx.meta.push(h)

    # docTitle
    docTitle = doc.get("//xmlns:docTitle", @namespaces_ncx).get("//xmlns:text", @namespaces_ncx)
    ncx.docTitle = docTitle.text()

    # navPoint
    #navs = doc.find("//xmlns:navPoint", @namespaces_ncx)
    #for nav in navs
    #  h = {}
    #  h[a.name()] = a.value() for a in nav.attrs()
    #  id = nav.attr('id').value()
    #  h.text = nav.get("//xmlns:navPoint[@id='#{id}']/xmlns:navLabel/xmlns:text", @namespaces_ncx).text()
    #  h.content = nav.get("//xmlns:navPoint[@id='#{id}']/xmlns:content", @namespaces_ncx).attr('src').value()
    #  ncx.navPoint.push(h)

    children = doc.childNodes();
    for c in children
      ncx = this.visit(c, 1, ncx)

    # playOrder で、昇順にソートする
    ncx.navPoint = ncx.navPoint.sort((a,b) -> parseInt(a.playOrder, 10) - parseInt(b.playOrder, 10))

    navs = doc.find("//xmlns:navPoint", @namespaces_ncx)
    navs = doc.find("//navPoint") if navs.length == 0
    ncx

  visit : (elem, level, ncx) ->
    children = elem.childNodes()
    level += 1 if elem.name() == 'navPoint'
    for c in children
      if c.name() == 'navPoint'
        h = {}
        h[a.name()] = a.value() for a in c.attrs()
        id = c.attr('id').value()
        h.text = c.get("//xmlns:navPoint[@id='#{id}']/xmlns:navLabel/xmlns:text", @namespaces_ncx).text()
        h.content = c.get("//xmlns:navPoint[@id='#{id}']/xmlns:content", @namespaces_ncx).attr('src').value()
        h.level = level
        ncx.navPoint.push(h)

      ncx = this.visit(c, level, ncx)

    ncx

  parse: (@epub_path, callback) ->
    epub_path = @epub_path
    epub3 = this

    throw new Error("file not found #{epub_path}") if !path.existsSync(epub_path)
    @zf = new zipfile.ZipFile(epub_path)

    this.checkMimetype (err, data) ->
      # console.log epub3
      info = epub3.parseSync(epub_path)
      callback(null, info) if callback

  parseSync: (@epub_path) ->
    epub_path = @epub_path
    @zf = null
    @dir = null
    @info = null

    container = null
    opf = null
    ncx = null

    # parse META-INF/container.xml
    throw new Error("file not found #{epub_path}") if !path.existsSync(epub_path)
    @zf = new zipfile.ZipFile(epub_path)

    this.checkMimetypeSync()
    container = this.parse_container()
    opf = this.parse_opf(container.opf_file)
    @dir = path.dirname(container.opf_file)
    # console.log "#{path.dirname(container.opf_file)}/#{opf.ncx_file}"

    try
      ncx = this.parse_ncx("#{@dir}/#{opf.ncx_file}")
    catch err
      ncx = this.parse_ncx("#{opf.ncx_file}")

    epub = {
      epub_dir: path.dirname(@epub_path)
      epub_name: path.basename(@epub_path)
      opf_dir: path.dirname(container.opf_file)
    }
    @info = {container:container, opf:opf, ncx:ncx, epub: epub}

  get_content_ids:  ->
    ans = []
    ans.push nav.id for nav in @info.ncx.navPoint
    ans

  get_item_ids:  ->
    ans = []
    ans.push item.id for item in @info.opf.item
    ans

  get_content: (file_path, callback) ->
    pathpart = file_path.split '#'
    p = "#{@dir}/#{pathpart[0]}"
    p = path.normalize(p)
    this.check_in_zip(p)
    @zf.readFile p, (err, data) ->
      callback(err, null)  if err
      callback(null, data.toString('utf-8'))

  get_image: (path, callback) ->
    pathpart = file_path.split '#'
    p = "#{@dir}/#{pathpart[0]}"
    p = path.normalize(p)
    this.check_in_zip(p)
    @zf.readFile p, (err, data) ->
      callback(err, null)  if err
      callback(null, data)

  check_in_zip: (c_path) ->
    for f in @zf.names
      return true if f == c_path
    throw new Error("zip has not #{c_path}")

module.exports = Epub3
