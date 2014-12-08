NodeWebKit_Service = require('../../../src/api/NodeWebKit-Service')
juice   = require('juice')
cheerio = require('cheerio')

describe 'nw-apps | REPL-GUI | test-editor', ->
  nodeWebKit = new NodeWebKit_Service()
  chrome     = null
  path_App   = '/nw-apps/REPL-GUI'.append_To_Process_Cwd_Path()
  html       = null
  $          = null
  $css       = null

  mapCSS = (callback)->
    editor_Page = path_App.path_Combine('editor.html')
    juice editor_Page, (err, cssHtml) ->
      $css = cheerio.load(cssHtml)
      callback()

  mapHtml = (callback)->
    chrome.dom_Document (root)->
      chrome.dom_Html root.nodeId, (data)->
        html = data.html
        $ =data.$
        callback()

  before (done)->
    nodeWebKit.path_App = path_App
    nodeWebKit.start ->
      chrome = nodeWebKit.chrome
      chrome.open 'app://nwr/editor.html', ->
        mapHtml ->
          mapCSS ->
            done()

  after (done)->
    @timeout(3000)
    0.wait ->
      nodeWebKit.stop  ->
        done()

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

      done()

        #console.log $('#editor').css('top')
        #html.log()

  it 'check html elements on page', (done)->
      $('title').text().assert_Is('REPL-GUI | Editor')
      css_Href    =  (link.attribs.href for link in $('link'))
      scripts_Src =  (script.attribs.src for script in $('script'))

      css_Href   .assert_Is([ 'lib/foundation.css' ])
      scripts_Src.assert_Is([ 'lib/ace.js', 'lib/ext-language_tools.js', 'app://nwr/lib/mode-coffee.js', undefined ])

      #for script of $('script')
      #  console.log script.attr('src')
      #  #console.log $('script').length
      done()