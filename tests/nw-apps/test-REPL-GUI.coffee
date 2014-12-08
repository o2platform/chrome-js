NodeWebKit_Service = require('../../src/api/NodeWebKit-Service')

describe 'nw-apps | test-REPL-GUI', ->
  nodeWebKit = new NodeWebKit_Service()
  chrome     = null
  path_App        = '/nw-apps/REPL-GUI'.append_To_Process_Cwd_Path()

  before (done)->
    nodeWebKit.path_App = path_App

    nodeWebKit.start ->
      chrome = nodeWebKit.chrome
      done()

  after (done)->
    nodeWebKit.stop ->
      done()

  it 'open Index page', (done)->
    #nodeWebKit.show ->
      chrome.html (value, $)->
        $('title').text().assert_Is('Node WebKit REPL | GUI')
        done()