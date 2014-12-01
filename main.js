
/*
var coffee = require('coffee-script');
var code = coffee._compileFile('./node_modules/fluentnode/src/fluent-array.coffee')
var gui = require('nw.gui'); 
gui.Window.get().eval(null,code)
*/
//[].add(12).first().log()
//a = require('fluentnode');
//var gui = require('nw.gui'); 
//gui.Window.get().eval(null,"var extra =" + a.extra); extra()

//var coffee = require('coffee-script')
//console.log(coffee)

//eval('./node_modules/fluentnode/node_modules/coffee-script/register');              // adding coffee-script support
/*var code = coffee._compileFile('./node_modules/fluentnode/src/fluent-array.coffee')
eval(console.log(code))
Array.prototype.size = function() { return 'this is the size'}
_array2 = [111,222]
console.log(_array2)
console.log(_array2.size())
//console.log(a.str().keys)
/*var win = nwgui.Window.get();
win.showDevTools('', true);
win.on("devtools-opened", function(url) {
    console.log("devtools-opened: " + url);
    document.getElementById('devtools').src = url;
});*/
//require('nw.gui').Window.get().showDevTools('preview', false);

/*global.$ = $;

var abar = require('address_bar');
var folder_view = require('folder_view');
var path = require('path');
var shell = require('nw.gui').Shell;

$(document).ready(function() {
  var folder = new folder_view.Folder($('#files'));
  var addressbar = new abar.AddressBar($('#addressbar'));

  folder.open(process.cwd());
  addressbar.set(process.cwd());

  folder.on('navigate', function(dir, mime) {
    if (mime.type == 'folder') {
      addressbar.enter(mime);
    } else {
      shell.openItem(mime.path);
    }
  });

  addressbar.on('navigate', function(dir) {
    folder.open(dir);
  });
});
*/