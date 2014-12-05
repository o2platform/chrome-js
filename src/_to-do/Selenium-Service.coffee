require 'fluentnode'
selenium = require('selenium-standalone');

class Selenium_Service
  constructor: (show_Logs, port)->
    @server    = null
    @port      = port || 4447
    @url_wd    = "http://localhost:#{@port}"
    @url_hub    = @url_wd.append("/wd/hub/static/resource/hub.html")
    @show_Logs = if typeof(show_Logs) is 'boolean' then show_Logs else false    # interesting issue here when trying to map this correctly

  start: (callback)=>
    spawnOptions = { stdio: 'pipe'}
    seleniumArgs = ['-Dwebdriver.chrome.driver=./node_modules/nodewebkit/nodewebkit/chromedriver', '-port',@port]

    @server = selenium(spawnOptions, seleniumArgs)
    if (@show_Logs)
      @server.stdout.on 'data', (output)-> console.log(output + "")
      @server.stderr.on 'data', (output)-> console.log(output.str().trim())

    @server.stderr.on 'data', (output)->
      if output.str().contains('Started org.openqa.jetty.jetty.Server@')
        callback() if callback

  stop:(callback) =>
    @server.on('exit', -> callback() if callback)
    process.kill(@server.pid)

module.exports = Selenium_Service