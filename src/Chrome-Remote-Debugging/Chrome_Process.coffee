require ('../extra_fluentnode')
Chrome    = require('chrome-remote-interface')

class Remote_Chrome_API
  constructor: (port_Debug, connect_To_Id)->
    @port_Debug     = port_Debug || 9222
    @url_Json       = "http://127.0.0.1:#{@port_Debug}/json"
    @page_Events    = new events.EventEmitter()
    @connect_To_Id = connect_To_Id || null
    @_chrome        = null
    @json_Options   = null


  connect: (callback)->
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

  add_Extra_Error_Handling: (callback)->
    #@nodeWebKit.open_Index =>
      code = "process.on('uncaughtException', function(err) { alert(err);});";
      @chrome.eval_Script code, (err,data)=>
        callback()
module.exports = Remote_Chrome_API

