wd = require('wd');
describe('test', function () {

it('connect to session', function(done) 
{
    console.log('before connect...')
    //var browser = wd.remote('http://localhost:4444/wd/hub');
    //browser.attach('6fbfede6-09c9-4706-975c-b1545fe3ca52', function(err, capabilities) {
    
    browser = wd.promiseChainRemote();
    browser.init({browserName:'chrome'});
    
    err = null
      // The 'capabilities' object as returned by sessionCapabilities
      if (err) { /* that session doesn't exist */ 
        console.log(err)
      }
      else {
            browser.get('http://localhost:1337', function(err,data) 
            {
                console.log(err)
                console.log(data)
                /*browser.safeExecute('2+2', function(err, res) {
                    console.log(err)
                    console.log(res)
                    done()
                });*/
                done();
            });
            
            //browser.get('http://localhost:1337')
            /*browser.elementByCss("grey", function(err, el) {
            //console.log(err)
            console.log(el)
            console.log(Object.keys(browser))
            //browser.title().then(function(err,title) {console.log(title)})
            done();
            browser.detach();*/
            //});
      }
    });

        
   // });
});