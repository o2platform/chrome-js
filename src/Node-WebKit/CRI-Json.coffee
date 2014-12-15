class CRI_Json
  constructor: (port)->
    @port = port

  create_Url     : (method         ) => "http://127.0.0.1:#{@port}/#{method}"
  GET            : (method,callback) => @create_Url(method).GET (data)->callback(data)
  GET_Json       : (method,callback) => @create_Url(method).json_GET callback
  activate       : (callback       ) => @GET_Json 'json/activate'   , callback
  close          : (id, callback   ) => @GET      "json/close/#{id}", @wait_for_Not_Id id, callback
  list           : (callback       ) => @GET_Json 'json/list'       , callback
  new            : (callback       ) => @GET_Json 'json/new'        , callback
  wait_For_Start : (callback       ) => @create_Url('json').json_GET_With_Timeout callback
  wait_For_Close : (callback       ) => @create_Url('').http_GET_Wait_For_Null callback

  list_By_Id     : (callback)=>
    @list (items)=>
      listById = {}
      (listById[item.id]= item for item in items)
      callback listById

  window_Ids : (callback)=>
    @list_By_Id (windows) =>
      callback(windows.keys())

  get_Window    : (id, callback)=>
    @list_By_Id (windows)=>
      callback windows[id] ?= null

  wait_for_Not_Id : (id, callback)=>
    count = 10
    check = ()=>
      @window_Ids (ids)->
        if ids.contains(id)
          if --count
            check.invoke_In(10)  # delay
          else
            callback(false)
        else
          callback(true)

module.exports = CRI_Json