#to add to fluentnode
Function::invoke_In           = (value   )-> setTimeout @, value
Function::sourceCode          = (        )-> @ + ""

Number::invoke_After          = (callback)-> setTimeout callback, @
Number::wait                  = Number::invoke_After
Number::assert_Bigger_Than    = (value   )-> (@ > value).assert_Is_True()
Number::assert_Smaller_Than   = (value   )-> (@ < value).assert_Is_True()
String::as_Json               = (        )->JSON.parse(@)
String::http_GET_With_Timeout = (callback)->
  timeout = 500
  delay   = 10;
  try_Http_Get = (next)   =>
    @.GET (data)        => if data is null then (delay).invoke_After next else callback(data)
  run_Tests = (test_Count)=> if test_Count.empty() then @.GET (callback) else try_Http_Get ()->run_Tests(test_Count.splice(0,1))
  run_Tests([0.. ~~(timeout/delay)])

