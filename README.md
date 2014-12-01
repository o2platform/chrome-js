REPL to dynamicaly execute selenium webdriver scripts (from https://github.com/admc/wd) inside a chrome-based node-webkit window (from https://github.com/rogerwang/node-webkit)


**how to run**

```
git clone https://github.com/o2platform/webkit-repl.git
cd webkit-repl
npm install 
'''
as per documented at https://github.com/rogerwang/node-webkit/wiki/Chromedriver you need to download the chrome driver for your platform 
from http://dl.node-webkit.org/v0.11.2/ and copy it into the ```./node_modules/nodewebkit/nodewebkit``` folder.

In OSx the file to download is the ```chromedriver-nw-v0.11.2-osx-x64``` and you can open the folder to copy the unziped file using ```open ./node_modules/nodewebkit/nodewebkit```

Once that is in place you can start the version with chromedriver support using
```
coffee launch.coffee
```

... which should look like this:

Note: in the current version, when you close the node-webkit window you will need to manually close the ```coffee launch.coffee``` process (since it is still running the
selenium server in the background)

If you want to just open the webkit-repl without chromedriver support, just run

```
./node_modules/.bin/nodewebkit 
```

... which should look like this:




**more script examples**
See these script examples to ideas on what to run there
```
https://gist.github.com/DinisCruz/516417b0e70a2ba5e8bb#file-91-multiple-google-searches-js
```

**related issues**
[Is there a GUI REPL for node-webkit?](https://github.com/rogerwang/node-webkit/issues/2702)
