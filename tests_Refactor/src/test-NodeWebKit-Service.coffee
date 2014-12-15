NodeWebKit_Service = require './../../src/api/NodeWebKit-Service'

describe 'test-NodeWebKit-Service |', ->



  it 'repl', (done)->
    nodeWebKit.repl (replServer)=>
      replServer.context.nwr.assert_Instance_Of(NodeWebKit_Service)
      replServer.on 'exit', =>
        done()
      replServer.commands['.exit'].action.apply(replServer)


  it 'extra method mappings',->
    nodeWebKit.show.assert_Is_Function()
    nodeWebKit.hide.assert_Is_Function()


  describe 'Need live window | ', ->
    before (done)-> nodeWebKit.start -> done()
    after  (done)-> nodeWebKit.stop -> done()

    it 'window_Show()', (done)->
      nodeWebKit.window_Show ->
        #todo: add way to check that window was opened
        #nodeWebKit.window_ShowDevTools ->
          nodeWebKit.window_Hide ->
           done()

    it 'window_New(), window_Get(), window_Close()', (done)->
      nodeWebKit.window_New (new_Window_Url)->
        nodeWebKit.windows (windows)=>
          windows.assert_Size_Is(2)
          nodeWebKit.window_Get new_Window_Url, (new_Window_NodeWebKit)->
            new_Window_NodeWebKit.assert_Instance_Of(NodeWebKit_Service)
            new_Window_NodeWebKit.chrome.assert_Is_Object()
            new_Window_NodeWebKit.chrome.connect_To_Id.assert_Is_String()
            new_Window_NodeWebKit.window_Close ->
              nodeWebKit.windows (windows)=>
                windows.assert_Size_Is(1)
                nodeWebKit.window_Get 'aaabbccc', (new_Window_NodeWebKit)->
                  assert_Is_Null(new_Window_NodeWebKit)
                  done()

    it 'windows()', (done)->
      nodeWebKit.windows (windows)->
        nodeWebKit.chrome.url_Json.json_GET (json)=>
          windows.assert_Is(json)
          done();

    it 'open_Url()', (done)->
      nodeWebKit.open_Url 'nw:about', ->
        nodeWebKit.chrome.html (value,$)->
          $('title').html().assert_Is('node-webkit')
          done();

    it 'open_Index()', (done)->
      nodeWebKit.open_Index ->
        nodeWebKit.chrome.html (value,$)->
          $('title').html().assert_Is('Node-WebKit-REPL | Simple Invisible')
          done();




return

xit 'capture screenshot', (done)->
  img_Foler = "_tmp_images".append_To_Process_Cwd_Path().folder_Create()
  file = img_Foler.path_Combine('aaa.png')
  chrome.Page.captureScreenshot (err, image)->

    require('fs').writeFile file, image.data, 'base64',(err)->
      console.log 'error:' + err
      "image saved on: #{file}".log()
    done()






return


describe 'test-NodeWebKit-Service', ->
  nodeWebKit = null
  selenium   = null
  browser    = null

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
        url.contains(nodeWebKit.path_App)

      #nodeWebKit.browser.window().on 'open', ->
      #'window was opened'.log
        #nodeWebKit.browser.window.assert_Not_Null()


      #nodeWebKit.browser.window.close()
      #nodeWebKit.browser.window.assert_Not_Null()
        nodeWebKit.window_Close =>
          done();
      #setTimeout done, 10000

