NodeWebKit_Service = require('../../src/api/NodeWebKit-Service')

describe 'nw-apps | test-Simple-Invisible', ->
  @timeout(5000)
  nodeWebKit = new NodeWebKit_Service()
  chrome     = null
  path_App        = '/nw-apps/Simple-Invisible'.append_To_Process_Cwd_Path()

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
      $('title').text().assert_Is('Node-WebKit-REPL | Simple Invisible')
      done()