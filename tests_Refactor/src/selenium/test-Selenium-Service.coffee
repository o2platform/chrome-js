Selenium_Service = require '../../../src/selenium/Selenium-Service'

describe 'test-Selenium-Service', ->
  show_Logs = false
  selenium = new Selenium_Service(show_Logs)

  it 'constructor',->
    Selenium_Service.assert_Is_Function()
    selenium.assert_Is_Object()
    assert_Is_Null(selenium.server)
    selenium.url_wd.assert_Contains('http').assert_Contains('localhost').assert_Contains(selenium.port)
    selenium.url_hub.assert_Contains(selenium.url_hub).assert_Contains('hub.html')
    selenium.show_Logs.str().assert_Is(show_Logs.str())

    new Selenium_Service(      ).show_Logs.assert_Is_True()
    new Selenium_Service(false ).show_Logs.assert_Is_False()
    new Selenium_Service(true  ).show_Logs.assert_Is_True()
    new Selenium_Service(0,1234).port     .assert_Is(1234)

  describe 'start and stop selenium server |', ->

    it 'check that server is NOT up',(done)->
      selenium.url_wd.GET (html)->
        assert_Is_Null(html)
        done()

    it 'start()', (done)->
      selenium.start.assert_Is_Function()
      selenium.start ->
        selenium.server.assert_Is_Not_Null()
        selenium.server.constructor.assert_Is_Function()
        selenium.server.constructor.name.assert_Is('ChildProcess')
        done();

    it 'check that server is up',(done)->
      selenium.url_hub.GET (html)->
        html.assert_Contains('<title>WebDriver Hub</title>')
        done()

    it 'stop()', (done)->
      selenium.stop.assert_Is_Function()
      selenium.stop(done)

    it 'check that server is NOT up',(done)->
      selenium.url_wd.GET (html)->
        assert_Is_Null(html)
        done()

  #see https://github.com/vvo/selenium-standalone/issues/40
  #it 'feature: selenium-standalone is using strerr instead of stdout',(done)->
  #  selenium = require('selenium-standalone');
  #  spawnOptions = { stdio: 'pipe' }
  #  seleniumArgs = []
  #  server = new selenium(spawnOptions, seleniumArgs)
  #  server.stdout.on 'data', (output)->
  #    throw 'if this thowns, it means the bug is fixed :)'
  #  server.stderr.on 'data', (output)->
  #    output.str().assert_Contains('INFO - Launching a standalone server')
  #    process.kill(server.pid)
  #    done()



