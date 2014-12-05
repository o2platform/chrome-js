NodeWebKit_Service = require '../app/NodeWebKit-Service'
Selenium_Service   = require '../app/Selenium-Service'

describe.only 'test-NodeWebKit-Service |', ->
  xdescribe 'core',->
    nodeWebKit = null

    before ->
      nodeWebKit = new NodeWebKit_Service()

    it 'constructor',->
      NodeWebKit_Service.assert_Is_Function()
      nodeWebKit.assert_Is_Object()
      #nodeWebKit.browser.assert_Instance_Of(require('wd').NodeWebKit_Service)
      nodeWebKit.first_Page    .assert_Contains('/html/index.html').assert_File_Exists();
      nodeWebKit.url_First_Page.assert_Contains(nodeWebKit.first_Page)

    it 'path_Executable()', ()->
      nodeWebKit.path_Executable().assert_Contains('node-webkit.app/Contents/MacOS/node-webkit')

    it 'start(), stop(), on_Exit()', (done)->
      @timeout(0)
      assert_Is_Null(nodeWebKit.process)
      nodeWebKit.start ->
        nodeWebKit.process.assert_Is_Object()
        nodeWebKit.process.pid.assert_Is_Number()
        nodeWebKit.stop(done)
        #(1000).eval_After ()->nodeWebKit.stop(done)

  describe 'live tests', ->
    nodeWebKit = null
    chrome     = null
    temp_NW    = '_tmp_nw'.append_To_Process_Cwd_Path()

    create_Temp_Nw = ->
      temp_NW.folder_Create()
      package_Json =
        name   : "temp-nw"
        version: "0.1.0"
        main   : ""
        window :
          position: "center"
          show    : true
      path_Package_Json = temp_NW.path_Combine('package.json')
      package_Json.json_pretty().saveAs(path_Package_Json)
      JSON.parse(path_Package_Json.file_Contents()).name.assert_Is('temp-nw')

    before (done)->
      nodeWebKit = new NodeWebKit_Service()
      nodeWebKit.url_Debug_Json.GET (data)->
        if data is null
          create_Temp_Nw()
          remove_debug_port = "--remote-debugging-port=#{nodeWebKit.port_Debug}"
          nodeWebKit.process = nodeWebKit.path_Executable().start_Process(temp_NW, remove_debug_port)
          process.nextTick(done)
        else
          done()
          #nodeWebKit.start(done)

    after (done)->
      #nodeWebKit.stop ->
      #  temp_NW.folder_Delete_Recursive().assert_Is_True()
      #  done()
      done()

    it 'connect_To_Chrome()', (done)->
      nodeWebKit.url_Debug_Json.GET (data)->
        #assert_Is_Null(data)
        nodeWebKit.connect_To_Chrome ()->
          chrome = nodeWebKit.chrome.assert_Is_Object()
          done()
          return;
          options = nodeWebKit.debug_Options.assert_Is_Object()
          options.id                  .split('-').assert_Size_Is(5)
          #options.url                 .assert_Is('file://' + temp_NW)  #'nw:blank')
          options.type                .assert_Is('page')
          options.title               .assert_Is('')
          options.description         .assert_Is('')
          #options.webSocketDebuggerUrl.assert_Is("ws://127.0.0.1:#{nodeWebKit.port_Debug}/devtools/page/#{options.id}")
          #options.devtoolsFrontendUrl .assert_Is("/devtools/devtools.html?ws=127.0.0.1:#{nodeWebKit.port_Debug}/devtools/page/#{options.id}")
          nodeWebKit.url_Debug_Json.wait_For_Http_GET (html)->
            html.assert_Is_String()
            done()

    it 'monitor requests', (done)->
      chrome.Network.enable (err, data)->
        console.log(err,data)
        chrome.Network.requestWillBeSent(console.log)
        chrome.Page.navigate {url: 'http://www.google.com'}, (err, data)->
          console.log err,data
          done()


    return

    it 'eval code', (done)->
      evaluate = nodeWebKit.chrome.Runtime.evaluate
      evaluate {returnByValue: true , expression: "iframe1.contentDocument.body.innerHTML = '12'"}, (err, data)->
        console.log err,data
        done()

    xit 'capture screenshot', (done)->
      img_Foler = "_tmp_images".append_To_Process_Cwd_Path().folder_Create()
      file = img_Foler.path_Combine('aaa.png')
      chrome.Page.captureScreenshot (err, image)->

        require('fs').writeFile file, image.data, 'base64',(err)->
          console.log 'error:' + err
          "image saved on: #{file}".log()
        done()

    return

    it 'eval code', (done)->
      evaluate = nodeWebKit.chrome.Runtime.evaluate
      evaluate {returnByValue: true , expression: "Object.keys(require('fs'))"}, (err, data)->
        console.log err,data
        done()

    it 'open google', (done)->
      chrome.Page.navigate {url: 'http://www.google.com'}, (err, data)->
        console.log err,data
          #chrome.Page.navigate {url: 'http://news.google.com'}, ->
           # chrome.Page.navigate {url: 'http://news.bbc.co.uk'}, ->
        500.invoke_After ()->done()

    it 'open bbc', (done)->
      chrome.Page.navigate {url: 'http://news.bbc.co.uk'}, (err, data)->
        console.log err,data
        1500.invoke_After ()->done()

    it 'open local page', (done)->
      chrome.Page.navigate {url: nodeWebKit.url_First_Page}, (err, data)->
        console.log err,data
        done()

    it 'wait a bit', (done)->
      #@timeout(0)
      #(2000).invoke_After done
      done();





return


describe 'test-NodeWebKit-Service', ->
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

