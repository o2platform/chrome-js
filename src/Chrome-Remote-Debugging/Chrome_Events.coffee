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



  wait_For_Complete: (callback)=>
  @chrome.page_Events.on 'loadEventFired', ()=>
    @html callback