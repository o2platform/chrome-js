var By = require('selenium-webdriver').By,
    until = require('selenium-webdriver').until
    firefox = require('selenium-webdriver/firefox');
    
// spec.js
describe('angularjs homepage', function() {
  
  /*beforeEach(function() {
    console.log('before')
    browser.ignoreSynchronization = true;
    //browser.get('http://localhost:1337');
    browser.driver.get('http://localhost:1337');
    console.log('after')
    
    //browser.debugger();
  });*/
  
  it('should have a title', function() {
    //driver = browser.driver;
    var driver = new firefox.Driver();
    driver.get('http://www.google.com/ncr');
    driver.findElement(By.name('q')).sendKeys('webdriver');
    driver.findElement(By.name('btnG')).click();
    driver.wait(until.titleIs('webdriver - Google Search'), 1000);
    driver.quit();    
    //done();
    return 
    //console.log(browser)    
    browser.getTitle().then(function(data) 
        {
            console.log('inside getTitle')
            console.log(data)            
        });
    //console.log(browser.driver.findElement(by.id('application')))    
    browser.driver.findElement(by.id('application'))
           .then(function(data)
           {
                console.log('inside then')
                console.log(data)
                done()
           });
    //console.log(browser.driver.find(By.id('application')))
    //browser.driver.find(By.id('application'))
    //expect(browser.getTitle()).toEqual('Super Calculator');
  });

  /*xit('should add one and two', function() {
    firstNumber.sendKeys(1);
    secondNumber.sendKeys(2);

    goButton.click();

    expect(latestResult.getText()).toEqual('3');
  });

  it('should add four and six', function() {
    // Fill this in.
    firstNumber.sendKeys(4);
    secondNumber.sendKeys(6);
    goButton.click();
    expect(latestResult.getText()).toEqual('10');
  });*/
});