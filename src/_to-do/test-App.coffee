return

#NOT USED AT THE MOMENT
App = require '.././app'

describe 'test-App', ->
    app = new App()

    before (done)->
        app.selenium_Service.start ->
            app.selenium_Service.url_wd.GET (html)->
                assert_Is_Not_Null(html)
                done()

    after (done)->
        app.selenium_Service.stop ->
            app.selenium_Service.url_wd.GET (html)->
                assert_Is_Null(html)
                done()

    it 'constructor',->
        App.assert_Is_Function()
        app.assert_Is_Object()
        app.selenium_Service.assert_Instance_Of(require('.././Selenium-Service'))

    it 'misc tests', (done)->
        app.selenium_Service.url_wd.GET (html)->
            assert_Is_Not_Null(html)
            done()
