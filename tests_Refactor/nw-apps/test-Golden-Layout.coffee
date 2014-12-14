NWR_Mocha = require('../../src/api/NWR-Mocha')

describe 'nw-apps | test-Golden-Layout', ->

  nwr = NWR_Mocha.create('/nw-apps/Golden-Layout', before,after)

  after (done)->
    nwr.nodeWebKit.stop ->
      done()

  it 'open Index page', (done)->
    #nodeWebKit.show ->
    #nwr.nodeWebKit.open_Index ->
      nwr.html  (value, $)->
        $('title').text().assert_Is('NWR - Golden-Layout')
        done()
