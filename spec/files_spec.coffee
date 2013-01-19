# epub3 のテスト

Files = require '../src/files'
fs = require 'fs'
util = require 'util'

describe 'unzip and rmdir', ->

  it 'rmdir', ->
    fs.mkdirSync('./zzz_000') unless fs.existsSync './zzz_000'
    expect(fs.existsSync('./zzz_000')).toEqual(true)
    fs.mkdirSync('./zzz_000/A')  unless fs.existsSync './zzz_000/A'

    Files.rmDirSyncRecursive './zzz_000'
    expect(fs.existsSync('./zzz_000/A')).toEqual(false)
    expect(fs.existsSync('./zzz_000')).toEqual(false)

  it 'unzip', ->
    Files.rmDirSyncRecursive('./zzz_001') if fs.existsSync './zzz_001'
    fs.mkdirSync './zzz_001'

    Files.unzip './spec/kusamakura.epub', './zzz_001', (err, stdout, stderr) ->
      expect(err).toEqual(null)
      expect(fs.existsSync('./zzz/OEBPS/Text/titlepage.xhtml')).toEqual(true)

      Files.rmDirSyncRecursive('./zzz_001') if fs.existsSync './zzz_001'
      expect(fs.existsSync('./zzz/OEBPS/Text/titlepage.xhtml')).toEqual(false)

#--- End of File ---
