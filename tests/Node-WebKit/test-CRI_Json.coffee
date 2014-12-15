NW_Process = require './../../src/Node-WebKit/NW-Process'
CRI_Json = require './../../src/Node-WebKit/CRI-Json'

describe 'test-CRI-JSON |', ->

  nwProcess = null
  cri       = null

  before (done)->
    NW_Process.get 'test-CRI-JSON', (_nwProcess)=>
      nwProcess = _nwProcess
      cri  = nwProcess.cri
      done()

  #after (done)->
  #  nwProcess.stop done

  it 'constructor',->
    nwProcess.assert_Instance_Of(NW_Process)
    cri.assert_Instance_Of(CRI_Json)
    cri.port.assert_Is(nwProcess.port)

  it 'GET()', (done)->
    cri.GET '',(data)->
      data.assert_Contains('<title>Content shell remote debugging</title>')
      done();

  it 'GET_Json(), list()', (done)->
    cri.GET_Json 'json',(data_1)->
      data_1.assert_Size_Is(1)
      data_1.first().devtoolsFrontendUrl.assert_Is_String()
      cri.list (data_2)->
        data_1.assert_Is(data_2)
        done();

  it 'new', (done)->
    cri.new (new_Window)->
      new_Window.devtoolsFrontendUrl.assert_Contains(cri.port)
      cri.list (windows)->
        windows.assert_Size_Is(2)
        windows.first().assert_Is(new_Window)
        done()


  it 'list_By_Id()',(done)->
    cri.list (list)->
      cri.list_By_Id (listById)->
        listById.keys().size().assert_Is(list.size())
        first = list.first();
        second = list.second();
        listById[first.id]       .assert_Is(first)
        listById[second.id]      .assert_Is(second)
        listById.keys().first()  .assert_Is(first.id)
        listById.keys().second() .assert_Is(second.id)
        done()

  it 'get_Window() , window_Ids()', (done)->
    cri.list_By_Id (list)->
      cri.window_Ids (ids)->
        first  = list[ids.first()];
        second = list[ids.second()];
        cri.get_Window first.id, (window)->
          window.id.assert_Is(first.id)
          cri.get_Window second.id, (window)->
            window.id.assert_Is(second.id)
            cri.get_Window 'aaa', (window)->
              assert_Is_Null(window)
              done()

  # make this the last one since once we close all windows the process will end
  it 'close', (done)->
    cri.list (windows)->
      windows.assert_Size_Is(2)
      cri.close windows.first().id, (result)->
        result.assert_Is_True()
        cri.list (windows)->
          windows.assert_Size_Is(1)
          cri.close windows.first().id, (result)->
            result.assert_Is_True()
            cri.wait_For_Close ->
              cri.GET 'json/list', (windows)->
                assert_Is_Null(windows)
                done()
