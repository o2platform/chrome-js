require 'fluentnode'

nodewebkit         = require 'nodewebkit'
Remote_Chrome_API  = require('../../src/api/Remote-Chrome-API')

class NodeWebKit_Service
  constructor: ->
    @path_App        = '/nw-apps/Simple-Invisible'.append_To_Process_Cwd_Path()
    @page_Index      = 'app://nwr/index.html'
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
    @process = @path_Executable().start_Process('--url=nw:about', "--remote-debugging-port=#{@port_Debug}", @path_App)
    @chrome.connect =>
      @open_Index =>
        callback() if callback

  stop: (callback)=>
    @process.on 'exit', ->
      callback()
    @process.kill()

  window_Show             : (callback)=> @chrome.eval_Script "require('nw.gui').Window.get().show()"         , callback
  window_Hide             : (callback)=> @chrome.eval_Script "require('nw.gui').Window.get().hide()"         , callback
  window_ShowDevTools     : (callback)=> @chrome.eval_Script "require('nw.gui').Window.get().showDevTools()" , callback
  window_HideDevTools     : (callback)=> @chrome.eval_Script "require('nw.gui').Window.get().closeDevTools()", callback

  window_Close            : (callback)=>
    @chrome.eval_Script "require('nw.gui').Window.get().close()",=>
      @chrome._chrome.close()
      @windows (windows)=>
        callback()

  window_New: (callback)=>
    new_Window_Url = 'nw://new-window-'.add_Random_Letters(16)
    @chrome.eval_Script "this['#{new_Window_Url}'] = require('nw.gui').Window.open('#{new_Window_Url}', { 'new-instance': true , show:false})", ->
      callback(new_Window_Url)

  window_Get: (window_Url,callback) =>
    @windows (windows)=>
      window = (window for window in windows when window.url is window_Url).first()
      if window is null
        callback null
      else
        new_Window_NodeWebKit = new NodeWebKit_Service()          # now that we can create new windows like this, maybe NodeWebKit-Service should be refactored to Window-Service
        new_Window_NodeWebKit.port_Debug = @port_Debug
        new_Window_NodeWebKit.process    = @process
        new_Window_NodeWebKit.chrome     = new Remote_Chrome_API(@port_Debug,window.id)
        new_Window_NodeWebKit.chrome.connect =>
          callback(new_Window_NodeWebKit)

  windows: (callback)=>
    @chrome.url_Json.json_GET callback


  show: (callback)=> @window_Show(callback)
  hide: (callback)=> @window_Hide(callback)

  open_Url: (url, callback)=>
    @chrome.open url, callback

  open_Index: (callback)=>
    @chrome.open @page_Index, callback

module.exports = NodeWebKit_Service



