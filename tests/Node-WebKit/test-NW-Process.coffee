NW_Process = require './../../src/Node-WebKit/NW-Process'

describe 'test-NW-Process |', ->
  describe 'Instance |',->

    nwProcess = null

    before ->
      nwProcess = new NW_Process()

    it 'constructor', (done)->
      NW_Process.assert_Is_Function()
      nwProcess.assert_Is_Object()
      using nwProcess , ->
        @options    .assert_Is({})
        @name       .assert_Is('--nwr-process')
        @path_App   .assert_Contains('/nw-apps/Simple-Invisible')
        @url_Default.assert_Is('app://nwr/index.html')
        @port       .assert_In_Between(50000,55000)
        @cri        .constructor.name.assert_Is('CRI_Json')
        assert_Is_Null(@process)
        done()

    it 'constructor (with options)', ->
      options = {name:'QA', port: 12345, path_App: 'abc', url_Default:'123'}
      nwProcess_With_Options = new NW_Process(options)
      using nwProcess_With_Options, ->
        @name       .assert_Is("--nwr-#{options.name}")
        @port       .assert_Is(options.port          )
        @path_App   .assert_Is(options.path_App      )
        @url_Default.assert_Is(options.url_Default   )

    it 'path_NW_Executable()', ()->
      if (require('os').platform() is 'darwin')
        nwProcess.path_NW_Executable().assert_Contains('node-webkit.app/Contents/MacOS/node-webkit')
      else
        nwProcess.path_NW_Executable().assert_Contains('nw')

    it 'start(), stop()', (done)->
      assert_Is_Null(nwProcess.process)
      using nwProcess, ->
        @start =>
          @process.assert_Is_Object()
          @process.pid.assert_Is_Number()
          @cri.window_Ids (ids)->
            ids.assert_Size_Is(1)
            nwProcess.stop(done)

  describe 'Static |', ->

    it 'find_NWR_Process_Ids , stop_All_NWR_Processes', (done)->
      name = 'QA_Test'
      NW_Process.find_NWR_Process_Ids name,( matches_Before_Start)->
        new NW_Process({name:name}).start ->
          NW_Process.find_NWR_Process_Ids name, (matches_After_Start)->
            NW_Process.stop_All_NWR_Processes ->
              NW_Process.find_NWR_Process_Ids null, (matches_After_Stop)->
                matches_After_Start.size().assert_Is(matches_Before_Start.size() + 1)
                matches_After_Stop.size().assert_Is(0)
                done();

    it 'get (with no running instance)',(done)->
      NW_Process.get (nwProcess)->
        nwProcess.name.assert_Is('--nwr-process')
        NW_Process.find_NWR_Process_Ids 'process',( matches_After_Start)->
          nwProcess.stop ->
            NW_Process.find_NWR_Process_Ids 'process',(matches_After_Stop)->
              matches_After_Start.assert_Size_Is(1)
              matches_After_Stop.assert_Size_Is(0)
              done()

    it 'get (with running instance)',(done)->
      name = "custom_name_".add_5_Random_Letters()                    # name of new NW_Process
      nwProcess_New = new NW_Process({name:name})                     # start NW_Process manually
      nwProcess_New.start ->
        NW_Process.get name, (nwProcess_Attached)->                   # get existing instance (ie attach)
          nwProcess_Attached.name.assert_Contains(name)
          NW_Process.get (nwProcess_Also_New)->                       # get new instance (is create)
            nwProcess_Also_New.name.assert_Contains('process')
            NW_Process.find_NWR_Process_Ids '', (matches)->           # get all NW_Process
              matches.assert_Size_Is(2)                               # there should be 2
              nwProcess_New.stop ->                                   # stop NW_Processes created
                nwProcess_Also_New.stop ->
                  NW_Process.find_NWR_Process_Ids '', (matches)->
                    matches.assert_Size_Is(0)                         # there should be zeo matches now
                    done();