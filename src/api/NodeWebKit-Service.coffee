require 'fluentnode'

nodewebkit         = require 'nodewebkit'
Remote_Chrome_API  = require('../../src/api/Remote-Chrome-API')

class NodeWebKit_Service
  constructor: ->
    @path_App        = '/nw-apps/Simple-Invisible'.append_To_Process_Cwd_Path()
    @port_Debug      = 50000 + ~~(Math.random()*5000)         #use a random port between 50000 and 55000
    @process         = null
    @chrome          = new Remote_Chrome_API(@port_Debug)

  path_Executable: ->
    nodewebkit.findpath()

  repl: (callback)=>
    replServer = @.repl_Me ()=>
    replServer.context.nwr = @
    callback (replServer) if callback

  start: (callback)=>
    @process = @path_Executable().start_Process("--remote-debugging-port=#{@port_Debug}", @path_App)
    @chrome.connect(callback)

  stop: (callback)=>
    @process.on 'exit', ->
      callback()
    @process.kill()


  window_Show             : (callback)=> @chrome.eval_Script "require('nw.gui').Window.get().show()"         , callback
  window_Hide             : (callback)=> @chrome.eval_Script "require('nw.gui').Window.get().hide()"         , callback
  window_ShowDevTools     : (callback)=> @chrome.eval_Script "require('nw.gui').Window.get().showDevTools()" , callback
  window_HideDevTools     : (callback)=> @chrome.eval_Script "require('nw.gui').Window.get().closeDevTools()", callback


  show: ()=> @window_Show()
  hide: ()=> @window_Hide()

module.exports = NodeWebKit_Service



