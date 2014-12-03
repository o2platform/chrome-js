url     = require('url')
cheerio = require('cheerio')
sessionId = null

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
 
 
add_Chai_Browser_Mode = function(next) 
  {    
    if (sessionId != null)  
    {      
      that._browser = function() 
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
    }
    else
      console.log('[WebDriver-support] No SessionId found so no _browser variable')
    next()
  }
  
  

setWebDriver = function()
  {        
      //if (typeof(browser) != 'undefined')
      //    next()
      //else                                    
    find_SessionId(function() {
      attach_To_SessionId(function(){
        add_Chai_Browser_Mode(function() {
          select_Frame1(function() {
                //showHref();                    
          })
        })
      })
    })
  }     

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
that = this;


//setup
var wd = require('wd');  
browser = wd.remote();

setWebDriver()