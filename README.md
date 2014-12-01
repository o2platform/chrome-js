Start selenium server using
```bash
java -jar /usr/local/lib/node_modules/nodewebkit/nodewebkit/selenium-server-standalone-2.44.0.jar -Dwebdriver.chrome.driver=/usr/local/lib/node_modules/nodewebkit/nodewebkit/chromedriver
```

Coffee script to open node-webkit and drive it using webdriver
```coffeescript
coffee protractor_tests/test_webkit.coffee
```

See these script examples to ideas on what to run there
```
https://gist.github.com/DinisCruz/516417b0e70a2ba5e8bb#file-91-multiple-google-searches-js
```
