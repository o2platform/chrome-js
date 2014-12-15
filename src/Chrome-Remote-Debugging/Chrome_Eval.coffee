runtime_Evaluate: (code, byValue, callback)=>
  @_chrome.Runtime.evaluate {expression: code , returnByValue: byValue},  (error, data) ->
    if callback not instanceof Function
      callback = (value, data)->console.log(data)

    if data.wasThrown or error
      callback(null, data)
    else
      if(data.result.value)
        callback(data.result.value, data)
      else
        callback(data.result.objectId, data)

eval_Script: (code,callback)=>
  @runtime_Evaluate(code, false, callback)

eval: (code, callback)->
    @chrome.eval_Script(code,callback)


get_Object: (value,callback)=>
  @runtime_Evaluate value, true, callback