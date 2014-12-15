Remote_Chrome_API  = require('../../src/api/Remote-Chrome-API')
NodeWebKit_Service = require('../../src/api/NodeWebKit-Service')


describe 'test-Remote_Chrome_API |',->
  nodeWebKit = null
  chrome     = null

 #before (done)->
 #  nodeWebKit = new NodeWebKit_Service()
 #  nodeWebKit.start ->
 #    chrome = nodeWebKit.chrome      # we need to get this object from here because nodeWebKit will create an NodeWebKit_Service object
 #    done()

 #after (done)->
 #  nodeWebKit.stop ->
 #    done()



  it 'connect()',(done)->
    chrome._chrome.assert_Is_Object()
    options = chrome.json_Options.assert_Is_Object()
    options.id                  .split('-').assert_Size_Is(5)
    options.url                 .assert_Contains('nw:about')
    options.type                .assert_Is('page')
    options.title               .assert_Is('')
    options.description         .assert_Is('')
    options.webSocketDebuggerUrl.assert_Is("ws://127.0.0.1:#{nodeWebKit.port_Debug}/devtools/page/#{options.id}")
    options.devtoolsFrontendUrl .assert_Is("/devtools/devtools.html?ws=127.0.0.1:#{nodeWebKit.port_Debug}/devtools/page/#{options.id}")
    done()

  it 'runtime_Evaluate', (done)->
    chrome.runtime_Evaluate '40+2', false, (data)->
      data.assert_Is(42)
      chrome.runtime_Evaluate 'var answer = {value: 42 }; answer', false, (data)->
        data.assert_Contains('{"injectedScriptId')
        chrome.runtime_Evaluate 'answer', true, (data)->
          data.assert_Is({ value: 42 })
          data.value.assert_Is(42)
          done()

  it 'eval_Script', (done)->
    chrome.eval_Script '40+2', (data)->
      data.assert_Is(42)
      done()

  it 'get_Object', (done)->
    chrome.get_Object 'window', (data)->
      assert_Is_Null(data)
      chrome.get_Object 'window.location', (data)->
        data.assert_Is_Object()
            .href.assert_Is(nodeWebKit.page_Index)
        done()

  it 'open()', (done)->
    chrome.open 'nw:about' , ()=>
      chrome.page_Events._events.keys().assert_Size_Is(1)
      #process.nextTick ->
      #  chrome.page_Events._events.keys().assert_Size_Is(1)
      done()

  it 'cookies, set_Not_HttpOnly_Cookies', (done)=>
    chrome.open 'app://cookie-domain/index.html', ->
      chrome.cookies (value)->
        value.assert_Is([])
        chrome.set_Not_HttpOnly_Cookies 'cookie_Key=Cookie_Value;abc=123', ->     # note that the 2nd cookie is not set here
          chrome.cookies (value)->
            value.assert_Size_Is(1)
            cookie = value.first()
            cookie.name  .assert_Is('cookie_Key')
            cookie.value .assert_Is('Cookie_Value')
            cookie.domain.assert_Is('cookie-domain')
            chrome.set_Not_HttpOnly_Cookies 'abc=123', ->
              chrome.cookies (value)->
                value.assert_Size_Is(2)
                cookie = value.second()
                cookie.name  .assert_Is('abc')
                cookie.value .assert_Is('123')
                cookie.domain.assert_Is('cookie-domain')
                chrome.delete_Cookie 'abc','http://cookie-domain/', ->
                  chrome.cookies (value)->
                    value.assert_Size_Is(1)
                    chrome.delete_Cookie 'cookie_Key','http://cookie-domain/', ->
                      chrome.cookies (value)->
                        value.assert_Size_Is(0)
                        done()


  it 'html()', (done)->
    chrome.open 'app://abc/index.html', ->
      chrome.html (value,$)->
        #console.log(value)
        value.contains('<html>')
        $('body h3').text().assert_Is('Node-WebKit-REPL')
        $('title'  ).text().assert_Is('Node-WebKit-REPL | Simple Invisible')
        value.assert_Contains($('html').html())
        value.assert_Is($.html())
        done()

  it 'dom_Document()',(done)->
    page ='app://abc/index.html'
    chrome.open page, ->
      chrome.dom_Document (document)->
        root = document.assert_Is_Object()
        root.nodeId.assert_Is_Number()
        root.nodeType.assert_Is(9)
        root.documentURL.assert_Is(page)
        root.baseURL.assert_Is(page)
        root.childNodeCount.assert_Is(2)
        root.children[0].nodeName.assert_Is('html')
        root.children[0].nodeType.assert_Is(10)
        root.children[1].nodeName.assert_Is('HTML')
        root.children[1].nodeType.assert_Is(1)
        root.children[1].childNodeCount.assert_Is(2)
        root.children[1].children[0].nodeName.assert_Is('HEAD')
        root.children[1].children[0].nodeType.assert_Is(1)
        root.children[1].children[1].nodeName.assert_Is('BODY')
        root.children[1].children[1].nodeType.assert_Is(1)
        root.children[1].children[0].attributes.assert_Is(['lang','en'])
        done()

  it 'dom_Html()', (done)->
    nodeWebKit.open_Index ->
      chrome.html (html_Direct)->
        chrome.dom_Document (document)->
          chrome.dom_Html document.nodeId, (html_Dom)->
            html_Direct.assert_Is(html_Dom.html.remove('<!DOCTYPE html>'))
            done()

  it 'dom_Find()', (done)->
    nodeWebKit.open_Index ->
      chrome.dom_Find 'body', (data)->
        data.html.assert_Is(data.$.html())
        data.$('h3').text().assert_Is('Node-WebKit-REPL')
        done()

  it 'dom_Find_All()', (done)->
    nodeWebKit.open_Index ->
      chrome.dom_Find_All 'p', (data)->
        data.assert_Size_Is(2)
        first_P = data[0]
        first_P.html.assert_Contains('This is the and index page')
        first_P.html.assert_Is(first_P.$.html())
        done();

  it 'show_Message', (done)->
    title   = 'abc_'.add_Random_Letters(16)
    message = '123_'.add_Random_Letters(16)
    chrome.show_Message title,message, ->                   # send a title, message and callback
      chrome.html (html, $)->
        $('#title').html().assert_Is(title)
        $('#message').html().assert_Is(message)
        chrome.show_Message message, ->                     # send a title and callback
          chrome.html (html, $)->
            $('#title').html().assert_Is(message)
            assert_Is_Null($('#message').html())
            done()
  it 'url', (done)->
    nodeWebKit.open_Index ->
      chrome.url (value)->
          value.assert_Is('app://nwr/index.html')
          done();
