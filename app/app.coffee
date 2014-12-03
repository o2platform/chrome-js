require 'fluentnode'

Selenium_Service = require('./Selenium-Service')

class App
  constructor:->
    @selenium_Service = new Selenium_Service()


module.exports = App

