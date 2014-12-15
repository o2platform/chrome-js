require 'fluentnode'
require '../extra_fluentnode'
nodewebkit         = require 'nodewebkit'


class NW_Process

  constructor: (options)->
    @options         = options || {}
    @name            = '--nwr-' + (@options.name || 'process')
    @path_App        = @options.path_App    || '/nw-apps/Simple-Invisible'.append_To_Process_Cwd_Path()
    @url_Default     = @options.url_Default || 'app://nwr/index.html'
    @port            = @options.port || 50000 + ~~(Math.random()*5000)         #use a random port between 50000 and 55000
    @url_Chrome      = "http://127.0.0.1:#{@port}/json"
    @process_Params  = ['--url=nw:about', "--remote-debugging-port=#{@port}", @path_App , @name]
    @process         = null
    @process_Id      = @options.process_Id || null


  path_NW_Executable: ->
    nodewebkit.findpath()

  start: (callback)=>
    @process = @path_NW_Executable().start_Process(@process_Params)
    @url_Chrome.json_GET_With_Timeout ()=>
      callback()

  stop: (callback)=>
    if @process is null
      if @processId isnt null
        process.kill(@processId)
      callback()
    else
      @process.on 'exit', =>
        callback()
      @process.kill()


# static methods

NW_Process.attach = (processId, port)->

NW_Process.find_NWR_Process_Ids = (name, callback)->

  if process.platform is 'win32'        # this method is not supported in windows
    callback([])
  else
    name ?= 'process'
    'ps'.start_Process_Capture_Console_Out 'ax', (data)->     # equivalent of running: #s ax | grep "node-webkit.*remote-debugging-port.*nw-apps" | awk "{ print $7 }" '
      matches = for line in data.trim().split('\n') when (line.contains('remote-debugging-port') and line.contains("--nwr-#{name}"))
        items = line.split(' ')
        { pid: items[1], port: items[15].split('=')[1] , name:items[17]}
      callback(matches)

NW_Process.stop_All_NWR_Processes = (callback)=>
  NW_Process.find_NWR_Process_Ids '', (matches)->
    for match in matches
      process.kill(match.pid)
    callback()

NW_Process.get = (name,callback)->
  if name instanceof Function
    callback = name
    name = null
  NW_Process.find_NWR_Process_Ids name, (matches)->
    if (not matches.empty())
      match = matches.first()                     # for now only use the first match
      nwProcess= new NW_Process({ name : name , port: match.port, process_Id : match.pid})
      callback(nwProcess)
    else
      nwProcess= new NW_Process()
      nwProcess.start ->
        callback(nwProcess)


module.exports = NW_Process



