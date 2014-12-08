require 'fluentnode'
require '../extra_fluentnode'

#NodeWebKit_Service= require('../api/NodeWebKit-Service')

#nodeWebKit = new NodeWebKit_Service()
#nodeWebKit.path_Executable().start_Process(nodeWebKit.path_App)

Selenium_Service  = require('./Selenium-Service')
WebDriver_Service = require('./WebDriver_Service')
class App
  constructor:->
    port = 5555
    @selenium_Service = new Selenium_Service(true, port)
    @webDriver_Service = new WebDriver_Service(port)
    @firstPage = 'file://' + 'nw-apps/REPL-Selenium/index.html'.append_To_Process_Cwd_Path()



console.log('about to start')
app = new App()

app.selenium_Service.start ->
  console.log('should had started...')
  #wd       = require 'wd'
  #browser  = wd.remote({port: app.selenium_Service.port});
  #browser.init {browserName:'chrome'}, (err, sessionID, capabilities)=>
  #  console.log err
  #  console.log sessionID
  #  #console.log browser

  app.webDriver_Service.connect_To_Browser ->
    firstPageUrl = app.firstPage + "?session_Id=" + app.webDriver_Service.session_Id
    app.webDriver_Service.browser.get firstPageUrl, (err)->
      'All done...'
  #connect_To_Browser ->

module.exports = App

