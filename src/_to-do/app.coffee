require 'fluentnode'

NodeWebKit_Service = require('./../api/NodeWebKit-Service.coffee')

nodeWebKit = new NodeWebKit_Service()
nodeWebKit.path_Executable().start_Process(nodeWebKit.path_App)

#Selenium_Service = require('./Selenium-Service')
#
#class App
#  constructor:->
#    @selenium_Service = new Selenium_Service()
#
#
#
#
#module.exports = App

