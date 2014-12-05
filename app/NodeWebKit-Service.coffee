require 'fluentnode'

#to add to fluentnode
Number::invoke_After      = (callback)-> setTimeout callback, @
String::wait_For_Http_GET = (callback)->
  timeout = 500
  delay   = 10;
  try_Http_Get = (next)   =>
    @.GET (data)        => if data is null then (delay).invoke_After next else callback(data)
  run_Tests = (test_Count)=> if test_Count.empty() then @.GET (callback) else try_Http_Get ()->run_Tests(test_Count.splice(0,1))
  run_Tests([0.. ~~(timeout/delay)])

async    = require 'async'
nodewebkit      = require 'nodewebkit'
Chrome          = require('chrome-remote-interface')


class NodeWebKit_Service
  constructor: ->
    @first_Page      = '.'
    @url_First_Page  = "file://#{@first_Page}"
    @process         = null
    @port_Debug      = 9229
    @chrome          = null
    @url_Debug_Json  = "http://127.0.0.1:#{@port_Debug}/json"
    @debug_Options   = null

  path_Executable: ->
    nodewebkit.findpath()

  on_Exit: (callback)->
    @process.on 'exit', ->
      process.nextTick(callback)

  start: (callback)=>
    @process = @path_Executable().start_Process("--remote-debugging-port=#{@port_Debug}")
    process.nextTick(callback)

  stop: (callback)=>
    @on_Exit callback
    @process.kill()

  connect_To_Chrome: (callback)->
    options = { host: '127.0.0.1', port: @port_Debug}
    @url_Debug_Json.wait_For_Http_GET (html)=>
      @debug_Options = JSON.parse(html).first()
      new Chrome options, (chrome)=>
        @chrome = chrome
        callback()


        

module.exports = NodeWebKit_Service


return



# the code below is more of a WebDriver_Service than an NodeWebKit_Service

wd       = require 'wd'
class __NodeWebKit_Service
  constructor: (wd_port)->
    @wd_port       = wd_port || 4444
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
      @browser.get "#{@first_Page}?sessionID=#{@browser.sessionID}",=>
        @browser.eval "console.log('hello')", (err, result)=>
          callback()

module.exports = NodeWebKit_Service


return

startNodeWebKit = ()->

  #firstPage = 'file:///Users/diniscruz/_Dev_Tests/node-webkit/my-first-test/index.html'






  attach_To_Browser_Session = (sessionId,next)->
    browser.attach sessionId, (error, value)->
      next()


  connect_To_Browser = (next)->
    url.GET_Json (data)->
      if (data.value.size() ==0)
        open_New_Browser_Session(next)
      else
        attach_To_Browser_Session(data.value.first().id,next)

  waitForServer ->
    connect_To_Browser ->



setupBrowserLogging = (browser)->
  browser.on 'status', (info) ->
    console.log('[browser][status]': + info)
  browser.on 'command', (eventType, command, response)->
    console.log('[browser][command] > ' + eventType, command, (response || ''))
    if command is 'close()'
      console.log('Window closed, so also stopping the selenium server')
      setTimeout process.exit, 200

  browser.on 'http', (meth, path, data)->
    console.log('[browser][http] > ' + meth, path, (data || ''))

startSeleniumServer()
startNodeWebKit()
