url     = require('url')
cheerio = require('cheerio')
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

map_Extra_Methods = function(wd)
{
    wd.addAsyncMethod('get',function(url) {
            var cb = wd.findCallback(arguments);           
            this.eval('window.location.href="'+url+'"', cb);                                    
        });
    wd.addAsyncMethod('html',function(url) {
            var cb = wd.findCallback(arguments);
            this.eval('document.body.innerHTML')
                .then(function(html){
                        cb(cbheerio.load(html))
                    });
        });
}

_browser = function() 
            {                
                var chai = require("chai");
                var chaiAsPromised = require("chai-as-promised");
                chai.use(chaiAsPromised);
                chai.should();
                wd = require('wd');
                map_Extra_Methods(wd)
                
                chaiAsPromised.transferPromiseness = wd.transferPromiseness;
                var browser = wd.promiseChainRemote();
                return browser.attach(sessionId)        
            }()

/*
 

        .get(about_page)
        .title(function(err, value) { show(value)} )
        .eval("window.location.href")
        .then(show)
*/        