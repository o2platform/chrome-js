#to add to fluentnode
Function::invoke_In           = (value   )-> setTimeout @, value
Function::sourceCode          = (        )-> @ + ""

Number::in_Between     = (min,max )-> (min < @ < max)
Number::log                   = -> console.log @.toString()
Number::invoke_After          = (callback)-> setTimeout callback, @
Number::wait                  = Number::invoke_After
Number::assert_Bigger_Than    = (value   )-> (@ > value).assert_Is_True()
Number::assert_Smaller_Than   = (value   )-> (@ < value).assert_Is_True()
Number::assert_In_Between     = (min,max )->  @.in_Between(min,max).assert_Is_True()
String::json_Parse            = (        )->  JSON.parse(@)
String::remove                = (value   )->  @.replace(value,'')

String::json_GET = (callback)->
  @.GET (data)->
    callback data.json_Parse()

String::json_GET_With_Timeout = (callback)->
  @.http_GET_With_Timeout (data)->
    callback data.json_Parse()

String::http_GET_With_Timeout = (callback)->
  timeout = 500
  delay   = 10;
  try_Http_Get = (next) =>
    @.GET (data)        => if data is null then (delay).invoke_After(next) else callback(data)
  run_Tests = (test_Count)=> if test_Count.empty() then @.GET (callback) else try_Http_Get ()->run_Tests(test_Count.splice(0,1))
  run_Tests([0.. ~~(timeout/delay)])

String::http_GET_Wait_For_Null = (callback)->
  timeout = 500
  delay   = 10;
  try_Http_Get = (next)   =>
    @.GET (data)        =>
      if data is null then callback() else next.invoke_In(delay)
  run_Tests = (test_Count)=> if test_Count.empty() then @.GET (callback) else try_Http_Get ()->run_Tests(test_Count.splice(0,1))
  run_Tests([0.. ~~(timeout/delay)])



#Extra helpers which are not prototypes
global.using = (ob,fn)-> fn.apply(ob)
global.log   = console.log

class Singleton
  __instance = null

  # Static singleton retriever/loader
  @get: ->
    if not @__instance?
      @__instance = new @
      @__instance.init()

    @__instance