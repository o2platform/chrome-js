require ('../extra_fluentnode')
Chrome    = require('chrome-remote-interface')
cheerio   = require('cheerio')
events    = require('events')
async     = require('async')

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
        callback null if callback
      else
        #console.log @json_Options.devtoolsFrontendUrl
        new Chrome options, (_chrome)=>
          #console.log "Got chrome: " + _chrome
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
      #console.log(">>> frameNavigated: #{data.json_pretty()}")
      #console.log(">>> frameNavigated #{data.frame.url}")
      eventKey = data.frame.id
      @page_Events.emit(eventKey)

    @_chrome.Page.domContentEventFired (data)=>
      #console.log(">>> domContentEventFired: #{data.json_pretty()}")

    @_chrome.Page.loadEventFired (data)=>
      #console.log(">>> loadEventFired: #{data.json_pretty()}")
      @page_Events.emit('loadEventFired')
      @page_Events.removeAllListeners('loadEventFired')

    @_chrome.DOM.documentUpdated ()=>
      #console.log(">>> documentUpdated:")

    @_chrome.Page.frameNavigated (data)=>

  open: (url,callback)=>
    @_chrome.Page.navigate {url:url},  (error, data)=>
      if not error
        eventKey = data.frameId
        @page_Events.removeAllListeners('loadEventFired')   # seems to be more reliable (but we don't an eventKey
        @page_Events.on 'loadEventFired', callback          # the problem is that at the moment if we get the DOM just after an frameNavigated, in losts of cases
                                                            # the DOM is not fully (loaded)

        @page_Events.removeAllListeners(eventKey)
        #@page_Events.on eventKey, callback


  html: (callback)=>
    @eval_Script 'document.documentElement.outerHTML', (value)->
      $ = if (value) then cheerio.load(value) else null
      callback(value, $)

  page_Index: (callback)->
    open 'App://nwr/index.html', callback

  dom_Document: (callback)=>
    @_chrome.DOM.getDocument (err, data)->
      callback(data.root)

  dom_Html: (nodeId,callback)=>
    @_chrome.DOM.getOuterHTML {nodeId:nodeId}, (err, data)=>
      value = data.outerHTML
      $ = if (value) then cheerio.load(value) else null
      callback {nodeId:nodeId, html:value, $:$}

  dom_Find: (selector, callback)=>
    @dom_Document (document)=>
      @_chrome.DOM.querySelector {nodeId:document.nodeId, selector:selector}, (err, result)=>
        nodeId = result.nodeId
        @dom_Html nodeId, callback

  dom_Find_All: (selector, callback)=>
    @dom_Document (document)=>
      @_chrome.DOM.querySelectorAll {nodeId:document.nodeId, selector:selector}, (err, results)=>
        all_Data = []
        map_NodeId_Html = (nodeId, next) =>
                            @dom_Html nodeId, (data)=>
                              all_Data.push(data)
                              next()

        async.each results.nodeIds, map_NodeId_Html, ()-> callback(all_Data)
module.exports = Remote_Chrome_API

