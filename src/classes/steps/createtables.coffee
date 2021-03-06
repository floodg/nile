{EventEmitter} = require 'events'
{spawn} = require 'child_process'
fs = require 'fs'
os = require 'os'
path = require 'path'
Template = require '../db/template'

module.exports =
class CreateTables extends EventEmitter
  constructor: (options) ->
    @msg_tag = 'createTables'
    @options = options
    @templateFile = path.join process.cwd(), 'sql', 'tables.sql'

  start: () ->
    if @options[@msg_tag]
      debug @msg_tag, 'create tables'
      fs.exists @templateFile, (exists)=> @libExists(exists)
    else
      @done()

  libExists: (exists) ->
    if exists
      debug @msg_tag, @templateFile + ' found'
      fs.readFile @templateFile, (err,data) => @onReadFile(err,data)
    else
      error @msg_tag, @templateFile + ' is missing'
      @done()

  onReadFile: (err,data) ->
    if err
      error @msg_tag, err
    else
      output = Template.render @options, data.toString('utf-8')
      fs.writeFile path.join( os.tmpdir(),'script.sql' ),output,(err) => @onWriteFile(err)

  onWriteFile: (err)->
    if err
      error @msg_tag, err
    else
      info @msg_tag, 'script created'
    opt =
      cwd: process.cwd()
      env: process.env
    proc = spawn 'psql',['-f', path.join( os.tmpdir(),'script.sql' ), '-p', @options.port,@options.database], opt
    proc.on 'close', (code) => @onLoadScript(code)
    proc.stderr.on 'data', (data) => @error(data)

  onLoadScript: (code) ->
    if code!=0
      error @msg_tag, 'script not loaded'
    else
      info @msg_tag, 'script loaded'
      @options.createFunctions = true # re-run
    @done()

  close: (code) ->
    debug @msg_tag, 'exit #'+code
    @done()
  output: (data) ->
    debug @msg_tag, data.toString()
  error: (data) ->
    info @msg_tag, data.toString().replace(/\n$/,'')
  done: () ->
    @emit 'done'
