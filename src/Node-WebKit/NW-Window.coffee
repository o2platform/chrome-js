require 'fluentnode'
require '../extra_fluentnode'

Chrome    = require('chrome-remote-interface')

class NW_Window
  constructor: (options)->
    @options = options || {}
    @port    = @options.port || 9222
    @chrome        = null


  connect: (callback)->
    callback()
    return
    options = { host: '127.0.0.1', port: @port_Debug}
    @url_Json.json_GET_With_Timeout (json)=>
      if @connect_To_Id is null
        @json_Options = json.first()
      else
        for item in json
          if item.id is @connect_To_Id
            @json_Options = item
            continue
      if @json_Options is null
        console.log '[connect] @json_Options  was null'
        callback null if callback
      else
        #console.log "1) #{@json_Options.devtoolsFrontendUrl}"
        new Chrome options, (_chrome)=>
          #console.log "2) Got chrome: #{ _chrome}"
          @_chrome = _chrome
          @hook_Events()
          #console.log "3) after hooking events: #{typeof(callback)}"
          callback() if callback

###
  constructor: (port_Debug, connect_To_Id)->

   @url_Json       = "http://127.0.0.1:#{@port_Debug}/json"
   @page_Events    = new events.EventEmitter()
   @connect_To_Id = connect_To_Id || null
   @_chrome        = null
   @json_Options   = null


 add_Extra_Error_Handling: (callback)->
   #@nodeWebKit.open_Index =>
   code = "process.on('uncaughtException', function(err) { alert(err);});";
   @chrome.eval_Script code, (err,data)=>
     callback
###

module.exports = NW_Window


###
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

  window_Position: (x,y,width,height, callback)=>
    @nodeWebKit.open_Index ()=>
      @chrome.eval_Script "curWindow = require('nw.gui').Window.get();
                           curWindow.x=#{x};
                           curWindow.y=#{y};
                           curWindow.width=#{width};
                           curWindow.height=#{height};
                           ", callback

  screenshot: (name, callback)=>
    safeName = name.replace(/[^()^a-z0-9._-]/gi, '_') + ".png"
    png_File = "./_screenshots".append_To_Process_Cwd_Path().folder_Create()
    .path_Combine(safeName)

    @chrome._chrome.Page.captureScreenshot (err, image)->
      require('fs').writeFile png_File, image.data, 'base64',(err)->
        callback()
###