url = require('url')

console.log('adding web driver support')

find_SessionId = function(next) 
    {   
        var rawQuery =url.parse(document.location.href).query
        if (rawQuery==null)
            return
        var query = rawQuery.split('=');
        if (query.length ==2 && query[0] == 'sessionID')
            sessionId = query[1]
        if(typeof(sessionId) == 'undefined')
            console.log('no sessionId')
        else
            next()
    }    
attach_To_SessionId = function(next)  { browser.attach(sessionId, function(error) { next() }) };
 
select_Frame1 = function(next)  { browser.frame('iframe1', next) }
showHref      = function()      { browser.eval("window.location.href", function(err, data) { view(data) } ) }    
 
setWebDriver = function(next)
    {
        if (typeof(browser) != 'undefined')
            next()
        else
            var wd = require('wd');  
            browser = wd.remote();
            
            find_SessionId(function() {
                attach_To_SessionId(function(){
                    select_Frame1(function() {
                        //showHref();
                        //view('all good so far')    
                        next()
                    })
                })
            })
    }
    
setWebDriver(function() {
    console.log("web driver is all set, opening up google")
    //browser.eval("window.location.href='http://www.google.com'", function() {})    
})    

nop = function() {} 

_browser = function() 
            {                
                var chai = require("chai");
                var chaiAsPromised = require("chai-as-promised");
                chai.use(chaiAsPromised);
                chai.should();
                wd = require('wd');
                wd.addAsyncMethod('get',
                                  function(url) {

                                    var cb = wd.findCallback(arguments);
                                    console.log('here')
                                    console.log(this)
                                    this.eval('window.location.href="'+url+'"', cb);                                    
                                  }
                                );
                
                chaiAsPromised.transferPromiseness = wd.transferPromiseness;
                var browser = wd.promiseChainRemote();
                return browser.attach(sessionId)        
            }()

Function.prototype._get = function() { return '_get'}
/*
//not working as expected 
Webdriver.prototype.get also doesn't work
browser_Get = function(url) 
{ 
    return this.eval('window.location.href="'+url+'"')
} */
/*
 

        .get(about_page)
        .title(function(err, value) { show(value)} )
        .eval("window.location.href")
        .then(show)
*/        