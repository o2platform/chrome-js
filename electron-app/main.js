var app = require('app');  // Module to control application life.
var BrowserWindow = require('browser-window');  // Module to create native browser window.

require('fluentnode')

// Report crashes to our server.
require('crash-reporter').start();

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the javascript object is GCed.
var mainWindow = null;

// Quit when all windows are closed.
app.on('window-all-closed', function() {
  // On OSX it is common for applications and their menu bar 
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform != 'darwin') {
    app.quit();
  }
});

// This method will be called when Electron has done everything
// initialization and ready for creating browser windows.
app.on('ready', function() {
  // Create the browser window.
  mainWindow = new BrowserWindow(
      {
          width: 800, height: 600,
          "web-preferences" : {
              images:false,
              security:true}
      });
  mainWindow.hide()
  // and load the index.html of the app.
  mainWindow.loadUrl('file://' + __dirname + '/index.html');

  // Open the devtools.
  mainWindow.openDevTools();
  mainWindow.setPosition( 961, 23 )
  mainWindow.setSize(516, 861)

  // Emitted when the window is closed.
  mainWindow.on('closed', function() {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null;
  });
  mainWindow.app = app

  mainWindow.webContents.on('did-finish-load', function() {
    console.log('----')
    console.log(mainWindow.webContents.executeJavaScript("alert('Hello There!');"));
    console.log(mainWindow.webContents.executeJavaScript("console.log('aaa');"));
    console.log(mainWindow.webContents.executeJavaScript("console.log(document)"));
    console.log('----')
  });
  mainWindow.show()


  //mainWindow.webview.addEventListener('console-message', function(e) {
  //  console.log('Guest page logged a message:', e.message);
  //});




  mainWindow.on('did-get-response-details', function(a,b)
    {
      console.log('did-get-response-details')
      console.log(a)
      console.log(b)
    });
  mainWindow.on('onbeforeunload', function()
    {
      console.log('onbeforeunload');
    });
  console.log('here')

  mainWindow.repl_Me()

});