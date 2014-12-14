NodeWebKit_Service = require('../../../src/api/NodeWebKit-Service')

describe 'test-Accessing-Node-WebKit |',->
  nodeWebKit = new NodeWebKit_Service()
  chrome     = null

  before (done)->
    nodeWebKit.start ->
      chrome = nodeWebKit.chrome
      done()

  after (done)->
    nodeWebKit.stop ->
      done()

  it 'confirm access to require(nw-gui) and Window.get() ', (done)->
    code = "require('nw.gui').Window.get()"
    chrome.eval_Script code,  (value, data)->
      value                  .assert_Is('{"injectedScriptId":1,"id":1}')
      data.result.type       .assert_Is('object')
      data.result.className  .assert_Is('Window')
      data.result.description.assert_Is('Window')
      done();

  it 'current Window position (vs package.json)', (done)->
    code = "var _window = require('nw.gui').Window.get();
            var value = {
                            x    : _window.x ,
                            y    : _window.y,
                            width: _window.width,
                            height: _window.height
                        };
            value;"
    chrome.get_Object code,  (value, data)->
      package_Json = nodeWebKit.path_App.path_Combine('package.json').file_Contents().json_Parse()
      value.width.assert_Is(package_Json.window.width)
      value.height.assert_Is(package_Json.window.height)
      value.x.assert_Bigger_Than(0)
      value.y.assert_Bigger_Than(0)
      done()

  it 'load nw:about', (done)->
    chrome.open 'nw:about', ->
      chrome.html (value,$)->
        $('title').text().assert_Is('node-webkit')
        node_Text =  "    .__   __.   ______    _______   _______         \n"    +
                     "    |  \\ |  |  /  __  \\  |       \\ |   ____|        \n" +
                     "    |   \\|  | |  |  |  | |  .--.  ||  |__    ______ \n"   +
                     "    |  . `  | |  |  |  | |  |  |  ||   __|  |______|\n"    +
                     "    |  |\\   | |  `--'  | |  '--'  ||  |____         \n"   +
                     "    |__| \\__|  \\______/  |_______/ |_______|"

        value.assert_Contains(node_Text)
        done()

  it 'load nw:version', (done)->
    chrome.open 'nw:version', ->
      chrome.html (value,$)->
        $('title').text().assert_Is('node-webkit versions')
        $('body').text().assert_Contains('node-webkit')
                        .assert_Contains('node.js')
                        .assert_Contains('Chromium')
                        .assert_Contains('commit hash')
        done()

  it 'load page and get event', (done)->
    url = 'app://abc/index.html'
    chrome.open url, ()->
      chrome.html (value,$)->
        $('title').html().assert_Is('Node-WebKit-REPL | Simple Invisible')
        done()

  it 'get document html via dom', (done)->
    chrome.open 'app://nwr/index.html', ->
      code = "document.body.innerHTML"
      chrome.eval_Script code,  (value, data)->
        value.assert_Contains('<h3 id="name">Node-WebKit-REPL</h3>')
        done();

  it 'getProperties of the document.body object',(done)->
    chrome.open 'app://nwr/index.html', ->
      chrome.eval_Script "document.body", (result, data)->
        chrome._chrome.Runtime.getProperties {objectId: result, ownProperties:true}, (error, data)->
          properties =  (item.name for item in data.result).sort()
          properties.assert_Contains('outerHTML')
          properties.assert_Contains('outerText')
          done()

  it 'dynamically invoke javascript via innerHTML script injection',(done)->
    chrome.open 'nw:about', ->
      chrome.eval_Script 'document.body.innerHTML="<img src=a onerror=document.write(42) />"', ()->
        chrome.html (value,$)->
          value.assert_Is('<html><head></head><body>42</body></html>')
          $('body').text().assert_Is(42)
          done()