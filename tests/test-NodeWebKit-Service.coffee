NodeWebKit_Service = require '../app/NodeWebKit-Service'
Selenium_Service   = require '../app/Selenium-Service'

describe 'test-NodeWebKit-Service-Service', ->
  nodeWebKit = null
  selenium   = null
  browser    = null

  @timeout(5000)
  
  before (done)->
    show_Logs  = true
    selenium   = new Selenium_Service(show_Logs)
    nodeWebKit = new NodeWebKit_Service(selenium.port)
    browser    = nodeWebKit.browser
    selenium.start(done)

  after (done)->
    selenium.stop(done)

  it 'constructor',->
    NodeWebKit_Service.assert_Is_Function()
    nodeWebKit.assert_Is_Object()
    #nodeWebKit.browser.assert_Instance_Of(require('wd').NodeWebKit_Service)
    nodeWebKit.browser     .assert_Is_Object()
    nodeWebKit.wd_port     .assert_Is(selenium.port)
    nodeWebKit.url_wd      .assert_Is(selenium.url_wd)
    nodeWebKit.url_sessions.assert_Is(selenium.url_wd + '/wd/hub/sessions')
    browser.assert_Is_Object()
           .assert_Is(nodeWebKit.browser)

  it 'sessions', (done)->
    nodeWebKit.sessions.assert_Is_Function()
    nodeWebKit.sessions (sessions)->
      sessions.assert_Is_Object()
      assert_Is_Null(sessions.sessionId)
      sessions.status.assert_Is(0)
      sessions.state.assert_Is('success')
      sessions.class.assert_Is('org.openqa.selenium.remote.Response')
      done()

  it 'window_Handles', (done)->
    nodeWebKit.window_Open =>
      nodeWebKit.window_Handles (windowsHandles)=>
        windowsHandles.assert_Size_Is(1)
        nodeWebKit.window_Close =>
          nodeWebKit.window_Handles (windowsHandles)=>
            windowsHandles.assert_Size_Is(0)
            done()

  #it 'url', (done)->
  #  done()

  it 'open_New_Browser_Session, url', (done)->

    nodeWebKit.open_New_Browser_Session ->
      nodeWebKit.window_Url (url)->
        url.contains(nodeWebKit.first_Page)

      #nodeWebKit.browser.window().on 'open', ->
      #'window was opened'.log
        #nodeWebKit.browser.window.assert_Not_Null()


      #nodeWebKit.browser.window.close()
      #nodeWebKit.browser.window.assert_Not_Null()
        nodeWebKit.window_Close =>
          done();
      #setTimeout done, 10000

