Remote_Chrome_API  = require('../../src/api/Remote-Chrome-API')
NodeWebKit_Service = require('../../src/api/NodeWebKit-Service')

describe 'test-Remote_Chrome_API |',->
  nodeWebKit = new NodeWebKit_Service()
  chrome     = null

  before (done)->
    nodeWebKit.start ->
      chrome = nodeWebKit.chrome      # we need to get this object from here because nodeWebKit will create an NodeWebKit_Service object
      done()

  after (done)->
    nodeWebKit.stop ->
      done()

  it 'constructor',->
    Remote_Chrome_API.assert_Is_Function()
    chrome.assert_Is_Object().assert_Instance_Of(Remote_Chrome_API)
    #assert_Is_Null(chrome.json_Options)
    #assert_Is_Null(chrome._chrome)

  it 'connect',(done)->
    #chrome.connect ->          # connect is called by nodeWebKit
    chrome._chrome.assert_Is_Object()
    options = chrome.json_Options.assert_Is_Object()
    options.id                  .split('-').assert_Size_Is(5)
    options.url                 .assert_Contains('/nw-apps/Simple-Invisible')
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
            .href.assert_Contains(nodeWebKit.path_App)
        done()

  it 'open()', (done)->
    chrome.open 'nw:version' , ()=>
      chrome.page_Events._events.keys().assert_Size_Is(1)
      process.nextTick ->
        chrome.page_Events._events.keys().assert_Size_Is(0)
        done()

  it 'html', (done)->
    chrome.open 'app://abc/index.html', ->
      200.wait ->
        chrome.html (value,$)->
          #console.log(value)
          value.contains('<html>')
          $('body h3').text().assert_Is('Node-WebKit-REPL')
          $('title'  ).text().assert_Is('Node-WebKit - Simple Invisible')
          value.assert_Contains($('html').html())
          value.assert_Is($.html())
          done()