libxmljs = require 'libxmljs'
assert = require 'assert'
fs = require 'fs'
path = require 'path'
util = require 'util'


get_text =  (node) ->
  return node if !node
  node.text()

parse_container =  (file_container_dir) ->
  str = fs.readFileSync("#{file_container_dir}/META-INF/container.xml", "utf8")
  doc = libxmljs.parseXmlString(str)
  # util.log doc.toString()

  rootfile = doc.get("//xmlns:rootfile", 'urn:oasis:names:tc:opendocument:xmlns:container').attr('full-path').value()
  "#{file_container_dir}/#{rootfile}"

parse_opf = (opf_file, file_root_dir) ->
  opf = {}
  opf.package = {}
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

  str = fs.readFileSync(opf_file, "utf8")
  doc = libxmljs.parseXmlString(str)
  # util.log doc.toString()

  # See
  # - http://idpf.org/epub/30/spec/epub30-publications.html#sec-package-def

  namespaces =  {xmlns: 'http://www.idpf.org/2007/opf', dc: "http://purl.org/dc/elements/1.1/"}

  # package
  package = doc.get("//xmlns:package", namespaces)
  for a in package.attrs()
    opf.package[a.name()] = a.value()

  # dc
  dc_identifier  = get_text
  dc_title       = get_text doc.get("//dc:title", namespaces)
  dc_language    = get_text doc.get("//dc:language", namespaces)
  dc_creator     = get_text doc.get("//dc:creator", namespaces)

  dc_contributor = get_text doc.get("//dc:contributor", namespaces)
  dc_coverage    = get_text doc.get("//dc:coverage", namespaces)
  dc_creator     = get_text doc.get("//dc:creator", namespaces)
  dc_date        = get_text doc.get("//dc:date", namespaces)
  dc_description = get_text doc.get("//dc:description", namespaces)
  dc_format      = get_text doc.get("//dc:format", namespaces)
  dc_publisher   = get_text doc.get("//dc:publisher", namespaces)
  dc_relation    = get_text doc.get("//dc:relation", namespaces)
  dc_rights      = get_text doc.get("//dc:rights", namespaces)
  dc_source      = get_text doc.get("//dc:source", namespaces)
  dc_subject     = get_text doc.get("//dc:subject", namespaces)
  dc_type        = get_text doc.get("//dc:type", namespaces)

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
  metas = doc.find("//xmlns:meta", namespaces)

  for m in metas
    h = {}
    for a in m.attrs()
      h[a.name()] = a.value()
    opf.meta.push(h)

  # link
  links = doc.find("//xmlns:link", namespaces)
  for link in links
    h = {}
    for a in link.attrs()
      h[a.name()] = a.value()
    opf.link.push(h)

  # manifest
  manifest = doc.get("//xmlns:manifest", namespaces)
  for a in manifest.attrs()
    opf.spine[a.name()] = a.value()

  # item
  items = doc.find("//xmlns:item", namespaces)
  for item in items
    h = {}
    for a in item.attrs()
      v = a.value()
      h[a.name()] = v
      opf.ncx_file = "#{file_root_dir}/#{item.attr('href').value()}"  if (v == 'ncx')

  opf.item.push(h)

  # spine
  spine = doc.get("//xmlns:spine", namespaces)
  for a in spine.attrs()
    opf.spine[a.name()] = a.value()

  # itemref
  itemrefs = doc.find("//xmlns:itemref", namespaces)
  for itemref in itemrefs
    h = {}
    for a in itemref.attrs()
      h[a.name()] = a.value()
    opf.itemref.push(h)

  # guide
  # eference
  refs = doc.find("//xmlns:reference", namespaces)
  for ref in refs
    h = {}
    for a in ref.attrs()
      h[a.name()] = a.value()
    opf.reference.push(h)

  # bindings
  # mediaType
  mts = doc.find("//xmlns:mediaType", namespaces)
  for mt in mts
    h = {}
    for a in mt.attrs()
      h[a.name()] = a.value()
    opf.mediatype.push(h)

  opf

class Epub3

  parse: (epub_root_path) ->

    # parse META-INF/container.xml
    container = {}
    container.root_file = parse_container(epub_root_path)
    container.file_root_dir = path.dirname(container.root_file)

    # parse content.opf
    opf = parse_opf(container.root_file, container.file_root_dir)

    # toc
    file_ncx = "#{opf.ncx_file}"

    str = fs.readFileSync(file_ncx, "utf8")
    doc = libxmljs.parseXmlString(str)

    ncx = {}
    ncx.meta = []
    ncx.docTitle = ""
    ncx.navPoint = []   # id, playorder, label content

    namespaces =  {xmlns: 'http://www.daisy.org/z3986/2005/ncx/'}

    # meta
    metas = doc.find("//xmlns:meta", namespaces)
    for m in metas
      h = {}
      for a in m.attrs()
        h[a.name()] = a.value()
      ncx.meta.push(h)

    # docTitle
    docTitle = doc.get("//xmlns:docTitle", namespaces).get("//xmlns:text", namespaces)
    ncx.docTitle = docTitle.text()

    # navPoint
    navs = doc.find("//xmlns:navPoint", namespaces)
    for nav in navs
      h = {}
      for a in nav.attrs()
        h[a.name()] = a.value()
      id = nav.attr('id').value()
      h.text = nav.get("//xmlns:navPoint[@id='#{id}']/xmlns:navLabel/xmlns:text", namespaces).text()
      h.content = nav.get("//xmlns:navPoint[@id='#{id}']/xmlns:content", namespaces).attr('src').value()
      ncx.navPoint.push(h)

      # playOrder で、昇順にソートする
      ncx.navPoint = ncx.navPoint.sort((a,b) -> parseInt(a.playOrder) - parseInt(b.playOrder))

    {container:container, opf:opf, ncx:ncx}

module.exports = Epub3