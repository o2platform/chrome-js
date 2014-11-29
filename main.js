console.log('here')
require('fluentnode')
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