require 'fluentnode'
require ('../extra_fluentnode')

async    = require 'async'
nodewebkit      = require 'nodewebkit'
Chrome          = require('chrome-remote-interface')


class NodeWebKit_Service
  constructor: ->
    @path_App        = '/nw-apps/Simple-Invisible'.append_To_Process_Cwd_Path()
    @port_Debug      = 50000 + ~~(Math.random()*5000)         #use a random port between 50000 and 55000
    @url_Json        = "http://127.0.0.1:#{@port_Debug}/json"
    @chrome          = null
    @json_Options    = null
    @process         = null

  path_Executable: ->
    nodewebkit.findpath()

  start: (callback)=>
    @process = @path_Executable().start_Process("--remote-debugging-port=#{@port_Debug}", @path_App)
    process.nextTick(callback)

  stop: (callback)=>
    @process.on 'exit', ->
      process.nextTick(callback)
    @process.kill()

  connect_To_Chrome: (callback)->
    options = { host: '127.0.0.1', port: @port_Debug}
    @url_Json.http_GET_With_Timeout (html)=>
      @json_Options = JSON.parse(html).first()
      new Chrome options, (chrome)=>
        @chrome = chrome
        callback()

  repl: (callback)=>
    @start =>
      @connect_To_Chrome =>
        replServer = @.repl_Me ()=>
        replServer.context.nwr = @
        callback (replServer) if callback

        

module.exports = NodeWebKit_Service



