// conf.js
exports.config = {
  seleniumAddress: 'http://localhost:4444/wd/hub',
  specs: ['test_webkit.js'],
  capabilities: {
    browserName: 'chrome'
  },
jasmineNodeOpts: {
    showColors: true,
    defaultTimeoutInterval: 3000
  }
}
