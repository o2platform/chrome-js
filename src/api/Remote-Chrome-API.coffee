require ('../extra_fluentnode')
Chrome          = require('chrome-remote-interface')

class Remote_Chrome_Api
  constructor: (port_Debug)->
    @port_Debug   = port_Debug || 9222
    @url_Json     = "http://127.0.0.1:#{@port_Debug}/json"
    @_chrome      = null
    @json_Options = null

  connect: (callback)->
    options = { host: '127.0.0.1', port: @port_Debug}
    @url_Json.http_GET_With_Timeout (html)=>
      @json_Options = JSON.parse(html).first()
      new Chrome options, (_chrome)=>
        @_chrome = _chrome
        callback() if callback

  runtime_Evaluate: (code, byValue, callback)=>
    @_chrome.Runtime.evaluate {expression: code , returnByValue: byValue},  (error, data) ->
      if callback
        if data.wasThrown or error
          callback(null, data)
        else
          if(data.result.value)
            callback(data.result.value, data)
          else
            callback(data.result.objectId, data)

  eval_Script: (code,callback)=>
    @runtime_Evaluate(code, false, callback)

  get_Object: (value,callback)=>
    @runtime_Evaluate value, true, callback


module.exports = Remote_Chrome_Api

