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

 # open: (url, callback)=>
 #   @chrome.open @tm_Server + url, =>
 #     @open_Delay.wait =>
 #ß       @html(callback)

  html: (callback)=>
    @chrome.html (html,$) =>
      callback(html,@add_Cheerio_Helpers($))

  show: (callback)-> @nodeWebKit.show(callback)

  wait_For_Complete: (callback)=>
    @chrome.page_Events.on 'loadEventFired', ()=>
      @html callback

  add_Cheerio_Helpers: ($)=>
    $.body = $('body').html()
    $.title = $('title').html()
    $.links = ($.html(link) for link in $('a'))
    $

  screenshot: (name, callback)=>
    safeName = name.replace(/[^()^a-z0-9._-]/gi, '_') + ".png"
    png_File = "./_screenshots".append_To_Process_Cwd_Path().folder_Create()
    .path_Combine(safeName)

    @chrome._chrome.Page.captureScreenshot (err, image)->
      require('fs').writeFile png_File, image.data, 'base64',(err)->
        callback()

  window_Position: (x,y,width,height, callback)=>
    @nodeWebKit.open_Index ()=>
      @chrome.eval_Script "curWindow = require('nw.gui').Window.get();
                           curWindow.x=#{x};
                           curWindow.y=#{y};
                           curWindow.width=#{width};
                           curWindow.height=#{height};
                           ", callback

  eval: (code, callback)->
    @chrome.eval_Script(code,callback)

  dom_Find     : (selector,callback)=>
    @chrome.dom_Find selector, (data)->
      callback(data.$)

  field: (selector, value, callback)=>
    if value instanceof Function
      callback = value
      value = null
      @chrome.dom_Find "input#{selector}", (data)->
        attributes = data.$('input').attr()
        callback(attributes)
    else
      "need to set the field".log()
      callback()


  click: (text, callback)->
    code = "elements = document.documentElement.querySelectorAll('a');
            for(var i=0; i< elements.length; i++)
              if(elements[i].innerText == '#{text}')
                elements[i].click();"
    @chrome.eval_Script code, (err,data)=>
      @wait_For_Complete =>
        @open_Delay.wait =>
          @html callback

  add_Extra_Error_Handling: (callback)->
    @nodeWebKit.open_Index =>
      code = "process.on('uncaughtException', function(err) { alert(err);});";
      @chrome.eval_Script code, (err,data)=>
        callback()


singleton  = null


NWR_Mocha.create = (before, after)->
  if singleton is null
    singleton = new NWR_Mocha()

  if typeof(before) == 'function'           # set these mocha events here so that the user (writting the unit test) doesn't have to
    before (done)->
      @.timeout(5000)
      singleton.before done
  if typeof(after) == 'function'
    after (done)-> singleton.after done
  return singleton

module.exports = NWR_Mocha