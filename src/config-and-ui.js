var gui  = require('nw.gui');
win = gui.Window.get();

var nativeMenuBar = new gui.Menu({ type: "menubar" });
try {
    nativeMenuBar.createMacBuiltin("My App", 
        {
          hideEdit: false,
          hideWindow: true
        });
    win.menu = nativeMenuBar;
    } catch (ex) {
        console.log(ex.message);
    }

reload_On_Changes = function()
{
    var path = './';
      var fs = require('fs');

      fs.watch(path, function() {
        if (location)
          location.reload();
      });
}


//util methods
var newWindow = function()
{
    var gui  = require('nw.gui');
    var new_win = gui.Window.get(window.open(document.location.href))
}

//setup

reload_On_Changes()