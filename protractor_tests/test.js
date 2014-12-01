var By = require('selenium-webdriver').By,
    until = require('selenium-webdriver').until
    firefox = require('selenium-webdriver/firefox');
    
var assert = require('assert')
 
describe('Google Search', function() {
  this.timeout(10000)
  it('should work', function(done) {
    var driver = new firefox.Driver();
    driver.get('http://www.google.com');
    var searchBox = driver.findElement(By.name('q'));
    searchBox.sendKeys('simple programmer');
    searchBox.getAttribute('value').then(function(value) {
      assert.equal(value, 'simple programmer//');
      //driver.quit();
      done()
      
    });
    
  });
});