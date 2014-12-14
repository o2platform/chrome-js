NodeWebKit_Service = require('../../../src/api/NodeWebKit-Service')

describe 'nw-apps | REPL-GUI | test-index', ->
  nodeWebKit = new NodeWebKit_Service()
  chrome     = null
  path_App        = '/nw-apps/REPL-GUI'.append_To_Process_Cwd_Path()

  before (done)->
    nodeWebKit.path_App = path_App

    nodeWebKit.start ->
      chrome = nodeWebKit.chrome
      #nodeWebKit.window_Show ->
      done()

  after (done)->
    nodeWebKit.stop ->
      done()

  afterEach (done)->
    #1000.wait ->
      done()

  it 'open Index page', (done)->
      chrome.html (value, $)->
        $('title').text().assert_Is('Node WebKit REPL | GUI')
        done()

  it 'app://nwr/editor.html', (done)->
    chrome.open 'app://nwr/editor.html', ->
      chrome.html (value, $)->
        $('title').text().assert_Is('REPL-GUI | Editor')
        done()

  it 'app://nwr/test.html', (done)->
    chrome.open 'app://nwr/test.html', ->
      chrome.html (value, $)->
        $('title').text().assert_Is('REPL-GUI | Test')
        done()

# xit 'open with DevTools', (done)->
#   @timeout(0)
#   nodeWebKit.window_Show ->
#     nodeWebKit.window_ShowDevTools ->
#       done()