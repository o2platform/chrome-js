return #was failing in travis (and all that code needs a refactoring)

NWR_Mocha = require('../../src/api/NWR-Mocha')

describe 'nw-apps | test-Golden-Layout', ->

  nwr = NWR_Mocha.create(before,after)
  chrome     = null
  path_App        = '/nw-apps/Golden-Layout'.append_To_Process_Cwd_Path()
  nwr.nodeWebKit.path_App = path_App


  after (done)->
    nwr.nodeWebKit.stop ->
      done()

  it 'open Index page', (done)->
    #nodeWebKit.show ->
    #nwr.nodeWebKit.open_Index ->
      nwr.html  (value, $)->
        $('title').text().assert_Is('NWR - Golden-Layout')
        done()
