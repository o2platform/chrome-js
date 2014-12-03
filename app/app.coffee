require 'fluentnode'
wd       = require('wd');
selenium = require('selenium-standalone');

startSeleniumServer = ()->
  spawnOptions = { stdio: 'pipe' }
  seleniumArgs = ['-Dwebdriver.chrome.driver=./node_modules/nodewebkit/nodewebkit/chromedriver']

  server = selenium(spawnOptions, seleniumArgs)

  server.stdout.on 'data', (output)-> console.log(output + "")
  server.stderr.on 'data', (output)-> console.log(output.str().trim())


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


startNodeWebKit = ()->

  browser = wd.remote();

  url = "http://localhost:4444/wd/hub/sessions"
  #firstPage = 'file:///Users/diniscruz/_Dev_Tests/node-webkit/my-first-test/index.html'
  firstPage = 'file:///Users/diniscruz/_Dev_Tests/node-webkit/my-first-test/html/index.html'
  waitForServer = (next)->    
      url.GET_Json (data)->
          if (data == null)
              console.log('[waiting for server]')
              setTimeout (()-> waitForServer(next)), 200
          else              
              next()

  open_New_Browser_Session = (next)->    
    browser.init {browserName:'chrome'},->  
      setupBrowserLogging(browser)
      browser.get "#{firstPage}?sessionID=#{browser.sessionID}",->
        browser.eval "console.log('hello')", (err, result)->          
          next()

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
      
startSeleniumServer()      
startNodeWebKit()
