program = require('../../bin/node-webkit-repl')

describe 'bin | node-web-kit-repl ', ->

  it 'options',->
    program.assert_Is_Object().assert_Instance_Of(require('commander').Command)
    program.options.assert_Is_Array().assert_Size_Is(1)
    program.commands.assert_Is_Array().assert_Size_Is(2)


  describe 'executing ./bin/node-webkit-repl', ->

    bin_node_webkit_repl = (params..., callback)->
      path = './bin/node-webkit-repl'.assert_File_Exists()
      path.start_Process_Capture_Console_Out params, callback

    it '(no params)', (done)=>
      bin_node_webkit_repl (result)=>
        result.assert_Contains('-h, --help     output usage information')
        done()

    it '--help)', (done)->
      bin_node_webkit_repl '--help',(result)->
        helpInformation = program.helpInformation()
        #helpInformation = helpInformation.replace('Usage: _mocha [options]', 'Usage: node-webkit-repl [options]') #hack to fix conflict with mocha (see https://github.com/tj/commander.js/issues/297)
        #result.assert_Is(helpInformation)
        result.assert_Contains('-h, --help     output usage information')
        done()

    #need to add test that detects the start of the repl
    #it '--repl)', (done)->
    #  bin_node_webkit_repl 'repl',(result)->
    #    console.log result
    #    done()

