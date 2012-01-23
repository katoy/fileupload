spawn = require('child_process').spawn
exec = require('child_process').exec

fs = require 'fs'
util = require 'util'

SRC_DIR = 'src'
ROUTES_DIR = 'routes'
SPEC_DIR = 'spec'
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
           appFiles.push currentFile
         else if stats.isFile() and currentFile.match(js_re) and not ~appFiles.indexOf( currentFile )
           jsFiles.push currentFile
         else if stats.isFile() and currentFile.match(back_re) and not ~appFiles.indexOf( currentFile )
           backFiles.push currentFile
         else if stats.isDirectory() and currentFile.indexOf('node_modules') < 0
             traverseFileSystem currentFile
  for folder in folders
    traverseFileSystem folder

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
  finds([SRC_DIR, ROUTES_DIR, SPEC_DIR])
  util.log "#{appFiles.length} coffee files found."
  util.log "#{jsFiles.length} js files found."
  util.log "#{backFiles.length} *~ files found."

task 'compile', 'Compile *.coffee', ->
  invoke 'count'
  util.log "compileing #{appFiles.length} files (*.coffee) ..."
  for file, index in appFiles then do (file, index) ->
    util.log "\t#{file}"
    run "coffee -c #{file}"

task 'clean', 'Clean compiled *.js *~', ->
  finds([SRC_DIR, ROUTES_DIR, SPEC_DIR])
  util.log "removing #{jsFiles.length}  files (*.js) ..."
  for file, index in jsFiles then do (file, index) ->
    util.log "\t#{file}"
    run "rm #{file}"

  finds([TOP_DIR])
  util.log "removing #{backFiles.length}  files (*.*~) ..."
  for file, index in backFiles then do (file, index) ->
    util.log "\t#{file}"
    run "rm #{file}"

# cake -e "development"
option '-e', '--environment [ENVIRONMENT_NAME]', 'set the environment for `task:run` (production|development, default=development)'
option '-p', '--port [ENVIRONMENT_NAME]', 'set the port for `task:run` (default=3000)'
task 'run', "run application", (options) ->
  options.environment or= 'development'
  options.port or= 3000
  run "NODE_ENV=#{options.environment} coffee server.coffee #{options.port}"

task "setup", "setup node-modules",  ->
  runSync "npm install", ->
    run "mkdir -p public/uploaded/files"
    run "mkdir -p public/unziped/files"

task "spec", "spec", ->
  run "jasmine-node spec --coffee spec"

task "test", "test and overage", ->
  console.log "------------------------------------"
  console.log "   After finished, See ./coverage.html for coverage."
  console.log "------------------------------------"
  run "vows --spec --cover-html"

task "inst", "inst", ->
  runSync "rm -fr src-inst", () ->
    run "mkdir src-inst"

  runSync "cake compile; jscoverage src src-inst", () ->
    run "mv src-inst/*.js src"

task "epubcheck3", "download and unzip epubchekc3", ->
  console.log "-------------------------------------"
  console.log "----  Do following operations.   ----"
  console.log "$ mkdir -p lib/epubcheck3"
  console.log "$ cd lib/epubcheck3"
  console.log "$ wget http://epubcheck.googlecode.com/files/epubcheck-3.0b4.zip"
  console.log "$ unzip epubcheck-3.0b4.zip"
  console.log "$ rm epubcheck-3.0b4.zip"
  console.log "--------------------------------------"

task "clean-epubcheck3", "clearn-epubcheck3", ->
  run "rm -fr lib/epubcheck3"
