require 'fluentnode'
require('../extra_fluentnode.coffee')
NodeWebKit_Service = require('./NodeWebKit-Service')

class NWR_Mocha

  constructor: ()->
    @nodeWebKit  = new NodeWebKit_Service(57777)
    nodeWebKit   = @nodeWebKit
    #@tm_Server   = 'http://localhost:1337'
    @chrome      = null
    @open_Delay  = 0

  before: (done)=>
    if not (@chrome is null)
      done()
      return;
    @nodeWebKit.chrome.url_Json.GET (data)=>
      if (data is null)
        @nodeWebKit.start =>
          @chrome = @nodeWebKit.chrome
          @add_Extra_Error_Handling done
      else
        @nodeWebKit.chrome.connect =>
          @chrome = @nodeWebKit.chrome
          done()

  after: (done)->
    if @chrome != null
      @chrome._chrome.close()
    @chrome = null
    done()

singleton  = null


NWR_Mocha.create = (path_App,before, after)->
  if singleton is null
    singleton = new NWR_Mocha()
    singleton.nodeWebKit.path_App = path_App.append_To_Process_Cwd_Path()

  if typeof(before) == 'function'           # set these mocha events here so that the user (writting the unit test) doesn't have to
    before (done)->
      @.timeout(5000)
      singleton.before done
  if typeof(after) == 'function'
    after (done)-> singleton.after done
  return singleton

module.exports = NWR_Mocha