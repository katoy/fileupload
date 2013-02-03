Sequelize = require 'sequelize'
util = require 'util'
path = require 'path'
CONFIG = require('config').db

trace = (m) ->
  util.log "# **** TRACE #{m}"

class Books
  constructor: (callback) ->
    trace "constractor"

    # callback(errs, db)
    @db = new Sequelize "database", "username", null,
      dialect: "sqlite"
      storage: CONFIG.database

    @book = @db.define 'books',
      file: Sequelize.STRING
      title: Sequelize.STRING
      format: Sequelize.STRING
      creator: Sequelize.STRING

      # for epub
      opf_file: Sequelize.STRING
      lang: Sequelize.STRING
      version: Sequelize.STRING

      identifier: Sequelize.STRING
      language: Sequelize.STRING
      contributor: Sequelize.STRING
      coverage: Sequelize.STRING
      date: Sequelize.STRING
      description: Sequelize.TEXT
      publisher: Sequelize.STRING
      relation: Sequelize.STRING
      rights: Sequelize.STRING
      source: Sequelize.STRING
      subject: Sequelize.STRING
      type: Sequelize.STRING

      # for PDF
      DocumentID: Sequelize.STRING
      InstanceID: Sequelize.STRING
      CreatorTool: Sequelize.STRING
      Producer: Sequelize.STRING
      Trapped: Sequelize.STRING
      CreateDate: Sequelize.STRING
      ModifyDate: Sequelize.STRING
      MetadataDate: Sequelize.STRING

    @db.sync().success (errs) ->
      callback(errs, CONFIG.database) if callback

  sync: () ->
    @db.sync (errs) ->

  drop: (callback)->
    trace "drop"

    # callback(err)
    @book.drop().success () ->
      callback(null) if callback

  addInfo_epub: (file, info, callback) ->
    trace "addInfo_epub"

    #console.log "-----------------------------"
    #console.log "#{info.opf.dc.description}"
    #console.log "#{info.opf.dc.description.length}" if info.opf.dc.description
    # callback(err, book)
    attr = {}

    attr.file = file

    attr.opf_file = info.container.opf_file
    attr.lang = info.opf.package_info.lang
    attr.version = info.opf.package_info.version

    attr.identifier = info.opf.dc.identifier
    attr.title = info.opf.dc.title
    attr.language = info.opf.dc.language
    attr.contributor = info.opf.dc.contributor
    attr.coverage = info.opf.dc.coverage
    attr.creator = info.opf.dc.creator
    attr.date = info.opf.dc.date
    attr.description = info.opf.dc.description
    attr.format = info.opf.dc.format
    attr.publisher = info.opf.dc.publisher
    attr.relation = info.opf.dc.relation
    attr.rights = info.opf.dc.rights
    attr.source = info.opf.dc.source
    attr.subject = info.opf.dc.subject
    attr.type = info.opf.dc.type

    util.log "Add epub #{attr}"
    @book.create(attr).success (book) ->
      callback(null, book) if callback

  addInfo_pdf: (file, info, callback) ->
    trace "addInfo_pdf"

    attr = {}

    attr.file = file
    attr.title = info.title
    attr.DocumentID = info.DocumentID
    attr.InstanceID = info.InstanceID
    attr.creator = info.creator 
    attr.CreatorTool = info.CreatorTool
    attr.Producer = info.Producer
    attr.Trapped = info.Trapped
    attr.format = info.format
    attr.CreateDate = info.CreateDate
    attr.ModifyDate = info.ModifyDate
    attr.MetadataDate = info.MetadataDate

    util.log "Add pdf #{attr}"
    @book.create(attr).success (book) ->
      callback(null, book) if callback

  del: (conf, callback) ->
    trace "del"

    # callback(err, num of deleted)
    @book.findAll(conf).success (books) ->
      b.destroy() for b in books
      callback(null, books.length) if callback

  findAll: (conf, callback) ->
    trace "findAll"

    # callbbakc(err, book[] )
    @book.findAll(conf).success (books) ->
      ans = []
      for b in books

        info = {}
        info.container = { opf_file: b.opf_file }
        info.opf = { package_info: {lang: b.lang, version: b.version} }
        info.opf.dc = {
                        identifier: b.identifier,
                        title: b.title,
                        language: b.language,
                        contributor: b.contributor,
                        coverage: b.coverage,
                        creator: b.creator,
                        date: b.date,
                        description: b.description,
                        format: b.format,
                        publisher: b.publisher,
                        relation: b.relation,
                        rights: b.rights,
                        source: b.source,
                        subject: b.subject,
                        type: b.type
                      }
        meta = {
          # file: b.file
          title: b.title
          format: b.format
          creator: b.creator
          # --- for epub
          # opf_file: b.opf_file
          lang: b.lang
          identifier: b.identifier
          language: b.language
          contributor: b.contributor
          coverage: b.coverage
          date: b.date
          description: b.description
          publisher: b.publisher
          relation: b.relation
          rights: b.rights
          source: b.source
          subject: b.subject
          type: b.type
          version: b.version
          # --- for PDF
          DocumentID: b.DocumentID
          InstanceID: b.InstanceID
          CreatorTool: b.CreatorTool
          Producer: b.Producer
          Trapped: b.Trapped
          CreateDate: b.CreateDate
          ModifyDate: b.ModifyDate
          MetadataDate: b.MetadataDate
        }
        ans.push { path: b.file, name: path.basename(b.file), info: info, meta: meta }

      callback(null, ans) if callback

  #  utils
  show_books: (books_ary) ->
    ans = []
    ans.push "#{b.id}, #{b.file}. #{b.title}, #{b.author}" for b in books_ary
    util.log ans

module.exports = Books
