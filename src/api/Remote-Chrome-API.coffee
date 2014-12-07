require ('../extra_fluentnode')
Chrome    = require('chrome-remote-interface')
cheerio   = require('cheerio')
events    = require('events')

class Remote_Chrome_API
  constructor: (port_Debug)->
    @port_Debug   = port_Debug || 9222
    @url_Json     = "http://127.0.0.1:#{@port_Debug}/json"
    @page_Events  = new events.EventEmitter()
    @_chrome      = null
    @json_Options = null


  connect: (callback)->
    options = { host: '127.0.0.1', port: @port_Debug}
    @url_Json.http_GET_With_Timeout (html)=>
      @json_Options = JSON.parse(html).first()
      new Chrome options, (_chrome)=>
        @_chrome = _chrome
        @hook_Events()
        callback() if callback

  runtime_Evaluate: (code, byValue, callback)=>
    #use base64 encoding to send code to execute to chrome runtime
    #code_Base64 = new Buffer(code).toString('base64')
    #codeToEval = "code = new Buffer('#{code_Base64}','base64').toString('ascii');
    #              new Function(code).apply(this)";
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

  hook_Events: ()=>
    @_chrome.Page.enable();
    @_chrome.Page.frameNavigated (data)=>
      #eventKey = "#{data.frame.id}_#{data.frame.url}"   # doesn't work unless we also track redirects
      eventKey = data.frame.id
      @page_Events.emit(eventKey)
      @page_Events.removeAllListeners(eventKey)

  open: (url,callback)=>
    @_chrome.Page.navigate {url:url},  (error, data)=>
      if not error
        eventKey = data.frameId
        @page_Events.on eventKey, callback

  html: (callback)=>
    @eval_Script 'document.documentElement.outerHTML', (value)->
      $ = if (value) then cheerio.load(value) else null
      callback(value, $)

module.exports = Remote_Chrome_API

