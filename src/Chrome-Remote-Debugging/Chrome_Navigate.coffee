open_Url: (url, callback)=>
  @chrome.open url, callback

open_Index: (callback)=>
  #console.log("Opening index page: #{@page_Index}")
  @chrome.open @page_Index, callback

    open: (url,callback)=>
    @_chrome.Page.navigate {url:url},  (error, data)=>
      if not error
        eventKey = data.frameId
        @page_Events.removeAllListeners('loadEventFired')   # seems to be more reliable (but we don't an eventKey
        @page_Events.on 'loadEventFired', callback          # the problem is that at the moment if we get the DOM just after an frameNavigated, in losts of cases
        # the DOM is not fully (loaded)

        @page_Events.removeAllListeners(eventKey)
  page_Index: (callback)->
    open 'App://nwr/index.html', callback

  cookies: (callback)=>
    @_chrome.Page.getCookies (err,data)->
      callback(data.cookies)

  delete_Cookie: (cookieName, url, callback)->
    @_chrome.Page.deleteCookie {cookieName:cookieName, url: url}, (err, data)->
      callback()

  set_Not_HttpOnly_Cookies: (value, callback)=>
    @eval_Script "document.cookie='#{value}'", callback
#@page_Events.on eventKey, callback
