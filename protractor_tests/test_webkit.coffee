require 'fluentnode'
wd = require('wd');
browser = wd.remote();

url = "http://localhost:4444/wd/hub/sessions"

open_New_Browser_Session = (next)->
  "creating new browser session".log()
  browser.init {browserName:'chrome'},->
    browser.get 'file:///Users/diniscruz/_Dev_Tests/node-webkit/my-first-test/index.html',->
      browser.eval "console.log('hello')", (err, result)->
        console.log browser.sessionID
        next()

attach_To_Browser_Session = (sessionId,next)->
  #sessionId = '23b386f8-e963-41b6-a753-9890bf11bc79'
  "attaching to browser session #{sessionId}".log()
  browser.attach sessionId, (error, value)->
    next()

connect_To_Browser = (next)->
  url.GET_Json (data)->
    if (data.value.size() ==0)
      open_New_Browser_Session(next)
    else
      attach_To_Browser_Session(data.value.first().id,next)

connect_To_Browser ->

return 

connect_To_Browser ->
  browser.get 'https://uno.teammentor.net/login' , ->
    browser.elementByName 'username', (error, el)->
      el.sendKeys 'graph' , ->
        browser.elementByName 'password', (error, el)->
          el.sendKeys 'xxxxxxx' , ->
            browser.elementById 'loginButton', (error, el)->
              el.click ->
                console.log 'all done'

return;

#browser.repl_Me()

connect_To_Browser ->
  browser.get 'https://www.google.com' , ->
    browser.elementByName 'q', (error, el)->
        el.sendKeys 'chrome repl' , ->
          browser.elementByName 'btnG', (error, el)->
            el.click ->
              console.log 'all done'

return


browser.attach sessionId, (error, value)->
    browser.get 'https://www.google.com', (error, value)->
      if error
        console.log error
        browser.init {browserName:'chrome'},->
          browser.get 'file:///Users/diniscruz/_Dev_Tests/node-webkit/my-first-test/index.html',->
            browser.eval "console.log('hello')", (err, result)->
              console.log browser.sessionID
      else
        console.log value
return


browser.init {browserName:'chrome'}, ->
  console.log 'after init'
  browser.get 'http://news.bbc.co.uk', ->
    browser.title (error, title)->
       browser.eval "window.location.href", (err, href)->
         console.log href
         console.log 'title: ' + title
         browser.eval "alert(12)", (err, result)->

return
##browser.init {browserName:'chrome'},->
browser.get 'file:///Users/diniscruz/_Dev_Tests/node-webkit/my-first-test/index.html',->
  browser.eval "console.log('hello')", (err, result)->
    console.log browser.sessionID

#setTimeout (()=>browser.close()), 6000

###
var By = require('selenium-webdriver').By,
    until = require('selenium-webdriver').until
    firefox = require('selenium-webdriver/chrome');

var assert = require('assert')

describe('Google Search', function() {
  this.timeout(10000)
  it('should work', function(done) {
    var driver = new chrome.Driver();
    driver.get('http://www.google.com');
    var searchBox = driver.findElement(By.name('q'));
    searchBox.sendKeys('simple programmer');
    searchBox.getAttribute('value').then(function(value) {
      assert.equal(value, 'simple programmer//');
      //driver.quit();
      done()

    });

  });
});
###
