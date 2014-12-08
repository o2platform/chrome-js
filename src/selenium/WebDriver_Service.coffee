
wd       = require 'wd'
class WebDriver_Service
  constructor: (wd_port)->
    @wd_port       = wd_port || 4447
    @browser       = wd.remote({port: wd_port});
    @url_wd        = 'http://localhost:' + @wd_port
    @url_sessions  = @url_wd + '/wd/hub/sessions'
    @session_Id     = null
    @capabilities   = null

  sessions: (callback)=>
    @url_sessions.GET_Json (sessions)->
      callback(sessions)

  window_Handles: (callback)=>
    @browser.windowHandles (err, windowHandles)=>
      callback(if err then [] else windowHandles)

  window_Close: (callback)=>
    @browser.close ()=> callback()

  window_Open: (callback)=>
    console.log "PORT " + @wd_port
    @browser.init {browserName:'chrome'}, (err, sessionID, capabilities)=>
      @session_Id = sessionID
      @capabilities = capabilities
      console.log("SESSION ID:" + @session_Id)
      callback()

  window_Url: (callback)=>
    @browser.url (err,url)=>
      callback(url)

  open_New_Browser_Session: (callback)=>
    @window_Open =>
      #setupBrowserLogging(browser)
      @browser.get "#{@path_App}?sessionID=#{@browser.sessionID}",=>
        @browser.eval "console.log('hello')", (err, result)=>
          callback()

  attach_To_Browser_Session: (sessionId,next)=>
    @browser.attach sessionId, (error, value)=>
      next()

  connect_To_Browser: (next)=>
    @url_sessions.GET_Json (data)=>
      if (data.value.size() ==0)
        @open_New_Browser_Session(next)
      else
        @attach_To_Browser_Session(data.value.first().id,next)

  setupBrowserLogging: (browser)=>
    @browser.on 'status', (info) =>
      console.log('[browser][status]': + info)
    @browser.on 'command', (eventType, command, response)->
      console.log('[browser][command] > ' + eventType, command, (response || ''))
      if command is 'close()'
        console.log('Window closed, so also stopping the selenium server')
        setTimeout process.exit, 200

    @browser.on 'http', (meth, path, data)->
      console.log('[browser][http] > ' + meth, path, (data || ''))


module.exports = WebDriver_Service
