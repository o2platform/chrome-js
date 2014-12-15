show_Message: (title, message, callback)=>
  if message instanceof Function
    callback = message
    message = ''
  else
    message = "<p id=\"message\">#{message}</p>"
  code="document.documentElement.innerHTML = '
              <link href=\"http://cdn.foundation5.zurb.com/foundation.css\" rel=\"stylesheet\"/>
                <div class=\"row\">
                  <div class=\"large-12 columns\">
                      <br/><br/>
                      <div class=\"panel\">
                        <h3 id=\"title\">#{title}</h3>
                        #{message}
                      </div>
                  </div>
                </div>' "
  code_Base64 = new Buffer(code).toString('base64')
  codeToEval = "code = atob('#{code_Base64}');new Function(code).apply(this)";
  @eval_Script codeToEval, (err, data)->
    callback()

