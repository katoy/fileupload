spawn = require('child_process').spawn
exec = require('child_process').exec

fs = require 'fs'
path = require 'path'
util = require 'util'

SRC_DIR = 'src'
SRC_INST_DIR = 'src-inst'
ROUTES_DIR = 'routes'
SPEC_DIR = 'spec'
TEST_DIR = 'test'
TOP_DIR = '.'

appFiles = []
jsFiles = []
backFiles = []

finds = (folders) ->
  coffee_re = new RegExp(/.*\.coffee$/)
  js_re = new RegExp(/.*\.js$/)
  back_re = new RegExp(/.*~$/)

  traverseFileSystem = (currentPath) ->
    files = fs.readdirSync currentPath
    for file in files
      do (file) ->
         currentFile = currentPath + '/' + file
         stats = fs.statSync(currentFile)
         if stats.isFile() and currentFile.match(coffee_re) and not ~appFiles.indexOf( currentFile )
           appFiles.push currentFile unless path.dirname(currentFile) == SPEC_DIR
         else if stats.isFile() and currentFile.match(js_re) and not ~jsFiles.indexOf( currentFile )
           jsFiles.push currentFile
         else if stats.isFile() and currentFile.match(back_re) and not ~backFiles.indexOf( currentFile )
           backFiles.push currentFile
         else if stats.isDirectory() and currentFile.indexOf('node_modules') < 0
           traverseFileSystem currentFile
  for folder in folders
    traverseFileSystem folder

  appFiles.push "public/javascripts/app.coffee"

run = (args...) ->
  for a in args
    switch typeof a
      when 'string' then command = a
      when 'object'
        if a instanceof Array then params = a
        else options = a
      when 'function' then callback = a

  command += ' ' + params.join ' ' if params?
  cmd = spawn '/bin/sh', ['-c', command], options
  cmd.stdout.on 'data', (data) -> process.stdout.write data
  cmd.stderr.on 'data', (data) -> process.stderr.write data
  process.on 'SIGHUP', -> cmd.kill()
  cmd.on 'exit', (code) -> callback() if callback? and code is 0

runSync = (str, callback) ->
  exec str, (err, stdout, stderr) ->
    console.log err  if err != null
    console.log stderr if stderr != null
    console.log stdout if !stdout != null
    callback() if callback != null

task 'count', 'how much files (*.coffee, *.js, *~)', ->
  finds([SRC_DIR, ROUTES_DIR, SPEC_DIR, TEST_DIR])
  util.log "#{appFiles.length} coffee files found."
  util.log "#{jsFiles.length} js files found."
  util.log "#{backFiles.length} *~ files found."

task 'compile', 'Compile **/*.coffee', ->
  invoke 'count'
  util.log "compileing #{appFiles.length} files (*.coffee) ..."
  for file, index in appFiles then do (file, index) ->
    util.log "\t#{file}"
    run "coffee -c #{file}"
  fs.unlinkSync "./coverage.html" if fs.existsSync "./coverage.html"

task 'clean', 'Clean compiled *.js *~', ->
  finds([SRC_DIR, ROUTES_DIR, SPEC_DIR, TEST_DIR])
  util.log "removing #{jsFiles.length}  files (*.js) ..."
  for file, index in jsFiles then do (file, index) ->
    if fs.existsSync "#{file}"
      util.log "\t#{file}"
      fs.unlinkSync "#{file}"

  run "rm *.js"

  finds([TOP_DIR])
  util.log "removing #{backFiles.length}  files (*.*~) ..."
  for file, index in backFiles then do (file, index) ->
    util.log "\t#{file}"
    fs.unlinkSync "#{file}"  if fs.existsSync "#{file}"

# cake -e "development"
option '-e', '--environment [ENVIRONMENT_NAME]', 'set the environment for `task:run` (production|development, default=development)'
option '-p', '--port [ENVIRONMENT_NAME]', 'set the port for `task:run` (default=3000)'
task 'run', "run application", (options) ->
  options.environment or= 'development'
  options.port or= 3000
  run "NODE_ENV=#{options.environment} coffee server.coffee #{options.port}"

task "setup", "setup node-modules",  ->
  run "mkdir -p public/uploaded/files"
  run "mkdir -p public/unziped/files"
  run "npm install"

task "setup:db", "setup emtpy databaese if nessesary",  ->
  unless fs.exists('database.sqlite')
    run "coffee createdb.coffee"

task "spec", "spec", ->
  run "NODE_ENV=test jasmine-node spec --coffee spec"

task "test", "test and overage", ->
  console.log "------------------------------------"
  console.log "   After finished, See ./coverage.html for coverage."
  console.log "------------------------------------"
  unless fs.existsSync 'public/uploaded/files/kusamakura.epub'
    # copy  to public/uploaded
    fs.createReadStream('spec/kusamakura.epub').pipe(fs.createWriteStream('public/uploaded/files/kusamakura.epub'))

  unless fs.existsSync 'public/unziped/files/kusamakura.epub'
    # unzip to public/unziped
    runSync 'coffee unzip.coffee spec/kusamakura.epub kusamakura.epub', ->
      fs.renameSync 'kusamakura.epub', 'public/unziped/files/kusamakura.epub'

  process.env.NODE_ENV='test'
  CONFIG = require('config').db

  database = CONFIG.database
  fs.unlinkSync(database) if fs.existsSync(database)
  run "NODE_ENV=test coffee add_epub.coffee"
  run "NODE_ENV=test vows --spec --cover-html test/list_test.coffee"
  # reporter:
  #   --json            Use JSON reporter
  #   --spec            Use Spec reporter
  #   --tap             Use TAP reporter
  #   --dot-matrix      Use Dot-Matrix reporter
  #   --xunit           Use xUnit reporter

task "inst", "inst", ->
  runSync "rm -fr #{SRC_INST_DIR}", ->
    run "mkdir #{SRC_INST_DIR}"

  runSync "cake compile; jscov #{SRC_DIR} #{SRC_INST_DIR}", ->
    run "mv #{SRC_INST_DIR}/*.js #{SRC_DIR}"

task "epubcheck3", "download and unzip epubchekc3", ->
  console.log "-------------------------------------"
  console.log "----  Do following operations.   ----"
  console.log "$ mkdir -p lib/epubcheck3"
  console.log "$ cd lib/epubcheck3"
  console.log "$ wget http://epubcheck.googlecode.com/files/epubcheck-3.0.zip"
  console.log "$ unzip epubcheckzip"
  console.log "$ rm epubcheck.zip"
  console.log "--------------------------------------"

task "clean-epubcheck3", "clearn-epubcheck3", ->
  run "rm -fr lib/epubcheck-3.0"

task "lint", "lint", ->
  run "coffee --lint *.coffee #{SRC_DIR}/*.coffee #{SPEC_DIR}/*.coffee"
