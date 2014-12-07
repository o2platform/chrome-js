NodeWebKit_Service = require('../../../src/api/NodeWebKit-Service')

describe 'test-Accessing-Node-WebKit',->
  nodeWebKit = new NodeWebKit_Service()
  chrome     = null

  before (done)->
    nodeWebKit.start ->
      chrome = nodeWebKit.chrome
      done()

  after (done)->
    nodeWebKit.stop ->
      done()

  @timeout(5000)

  it 'confirm access to require(nw-gui) and Window.get() ', (done)->
    code = "require('nw.gui').Window.get()"
    chrome.eval_Script code,  (value, data)->
      console.log value
      value                  .assert_Is('{"injectedScriptId":1,"id":1}')
      data.result.type       .assert_Is('object')
      data.result.className  .assert_Is('Window')
      data.result.description.assert_Is('Window')
      done();

  xit 'bug: dummy request to give time to page to be loaded', (done)->
    code = "document.body.innerHTML"
    chrome.eval_Script code, (value, data)->
      assert_Is_Null(value)
      data.wasThrown.assert_Is_True()
      data.exceptionDetails.text.assert_Is('Uncaught TypeError: Cannot read property \'innerHTML\' of null')
      done()

  xit 'get document html via dom', (done)->
    code = "document.body.innerHTML"
    chrome.eval_Script code,  (value, data)->
      done();

  xit 'getProperties of the document.body object',(done)->
    code = "document.body"
    chrome.eval_Script code, (result, data)->
      console.log(result)
      console.log(data)
      chrome._chrome.Runtime.getProperties {objectId: result, ownProperties:true}, (error, data)->
        properties =  (item.name for item in data.result).sort()
        properties.assert_Contains('outerHTML')
        properties.assert_Contains('outerText')
        done()

  #it 'access nw-window',(done)->
  #  #@timeout(100000)
  #  chrome.eval_Script "require('nw.gui').Window.get().show()",  (result...)->
  #    chrome.eval_Script 'document.body.innerHTML="<img src=a onerror=document.write(12) />"', (result...)->
  #      #console.log(result)
  #      chrome.eval_Script 'document.body.innerHTML',  (result...)->
  #        #console.log result
  #        500.invoke_After ()->
  #          chrome.eval_Script 'document.body["innerHTML"]',  (result...)->
  #          console.log result
  #          #1200.invoke_After done
  #          done()
