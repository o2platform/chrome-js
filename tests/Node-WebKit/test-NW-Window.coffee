NW_Window  = require './../../src/Node-WebKit/NW-Window'
NW_Process = require './../../src/Node-WebKit/NW-Process'

describe 'test-NW-Window |', ->

  nwProcess = null
  nwWindow  = null

  before (done)->
    nwWindow  = new NW_Window()
    NW_Process.get 'NW_Window', (_nwProcess)->
      nwProcess = _nwProcess
      done()

  after (done)->
    NW_Process.stop_All_NWR_Processes ->
      done()

  it '_before',->
    NW_Window.assert_Is_Function()
    nwWindow.assert_Is_Object()
    nwProcess.assert_Is_Object()

  it 'constructor()', ->
    nwWindow.port.assert_Is(9222)
    assert_Is_Null nwWindow.chrome

    #  new_Chrome.url_Json.assert_Contains(new_Chrome.port_Debug)
    #  new_Chrome.page_Events.assert_Instance_Of(require('events').EventEmitter)
    #  assert_Is_Null(new_Chrome.connect_To_Id)
    #  assert_Is_Null(new_Chrome.json_Options)


  it 'connect()', (done)->
    nwWindow.connect ->
      done()