require 'fluentnode'
selenium = require('selenium-standalone');

spawnOptions = { stdio: 'pipe' }
seleniumArgs = ['-Dwebdriver.chrome.driver=./node_modules/nodewebkit/nodewebkit/chromedriver']



server = selenium(spawnOptions, seleniumArgs)

server.stdout.on 'data', (output)-> console.log(output + "")
server.stderr.on 'data', (output)-> console.log(output.str().trim())


wd = require('wd');
browser = wd.remote();

#exe_path = 'java'
#args = ['-jar', './node_modules/protractor/selenium/selenium-server-standalone-2.44.0.jar','-Dwebdriver.chrome.driver=./node_modules/nodewebkit/nodewebkit/chromedriver']

#args = ['-version']
#child = require('child_process').execFile exe_path, args, (err, stdout, stderr) -> 
                                                                                   


#console.log child

url = "http://localhost:4444/wd/hub/sessions"
firstPage = 'file:///Users/diniscruz/_Dev_Tests/node-webkit/my-first-test/index.html'
waitForServer = (next)->    
    url.GET_Json (data)->
        if (data == null)
            console.log('[waiting for server]')
            setTimeout (()-> waitForServer(next)), 200
        else
            console.log 'GOT DATA'
            next()
    
open_New_Browser_Session = (next)->
  "creating new browser session".log()
  browser.init {browserName:'chrome'},->  
    browser.get "#{firstPage}?sessionID=#{browser.sessionID}",->
      browser.eval "console.log('hello')", (err, result)->
        console.log browser.sessionID
        next()

attach_To_Browser_Session = (sessionId,next)->  
  "attaching to browser session #{sessionId}".log()
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
