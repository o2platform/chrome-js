#NodeWebKit_Service = require('../../../src/api/NodeWebKit-Service')
NWR_Mocha = require('../../../src/api/NWR-Mocha')

juice   = require('juice')
cheerio = require('cheerio')

describe 'nw-apps | REPL-GUI | test-editor', ->
#  nodeWebKit = new NodeWebKit_Service()
#  chrome     = null
  path_App   = '/nw-apps/REPL-GUI'.append_To_Process_Cwd_Path()
  nwr = NWR_Mocha.create('/nw-apps/REPL-GUI',before,after)
  chrome     = null
  html       = null
  $          = null
  $css       = null

  #@timeout(5000)


  mapCSS = (callback)->
    try
      editor_Page = path_App.path_Combine('editor.html')
      juice editor_Page, (err, cssHtml) ->
        $css = cheerio.load(cssHtml)
        callback()
    catch error
      console.log error

  mapHtml = (callback)->
    nwr.chrome.dom_Document (root)->
      nwr.chrome.dom_Html root.nodeId, (data)->
        html = data.html
        $ =data.$
        callback()

  before (done)->
    nwr.nodeWebKit.show ->
      nwr.window_Position 1000,40,600,1000, (err,data)->
        500.wait ->
          done()



  after (done)->
    #nwr.nodeWebKit.stop()
    done()


  before (done)->
#    nodeWebKit.path_App = path_App
#    250.wait ->
#      nodeWebKit.start ->
#        chrome = nwr.nodeWebKit.chrome
#        #console.log "Chrome: " + chrome
        nwr.chrome.open 'app://nwr/editor.html', ->
            mapHtml ->
              mapCSS ->
                done()
#
#  after (done)->
#    @timeout(3000)
#    0.wait ->
#      nodeWebKit.stop  ->
#        done()

  afterEach (done)->
    #1000.wait ->
    done()

  it 'check css', (done)->
      editor_Css = $css('#editor').css()
      editor_Css.width     .assert_Is('70%')
      editor_Css.top       .assert_Is('30px')
      editor_Css.border    .assert_Is('0px')
      editor_Css.position  .assert_Is('absolute')
      editor_Css.bottom    .assert_Is('0px')
      editor_Css.background.assert_Is('#9bb5de')

      button_Css = $css('button').css()
      editor_Css["box-sizing"].assert_Is('border-box') # foundation added element
      #button_Css.json_pretty().log()

      done()

        #console.log $('#editor').css('top')
        #html.log()

  it 'check html elements on page', (done)->
      done()
      return
      $('title').text().assert_Is('REPL-GUI | Editor')
      css_Href    =  (link.attribs.href for link in $('link'))
      scripts_Src =  (script.attribs.src for script in $('script'))

      css_Href   .assert_Is([ 'css/foundation.css' ,'css/editor.css'])
      scripts_Src.assert_Is([ 'lib/ace.js', 'lib/ext-language_tools.js', 'app://nwr/lib/mode-coffee.js', undefined ])

      done()