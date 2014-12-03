coffee = require('coffee-script')
var util = require('util') 
// menu support

that = this
if (!localStorage['index']) 
    localStorage['index'] = 0



var show = function(value1, value2)
{
    value = value1 ? value1 : value2
    executionResult.html(util.inspect(value))
}
var log = show
var view = function(value1, value2)
{
    value = value1 ? value1 : value2
    viewData = function(data)
    {
        $(iframe1.contentDocument).find('#code').html(data)
    }
    try
    {
        viewData(JSON.stringify(value,null, ' '))
    }
    catch(error)
    {
        viewData(util.inspect(value))
    }
}

iframe2.onload = function()
 {       
    iframe = $($('.iframe2').contents())
    button = iframe.find('button')
    executionResult = iframe.find('#executionResult')
    editor = win.eval(iframe2,'editor')    

    button.on('click', function() {      
        executionResult.html('executing...')
        code = editor.getSession().getValue()
        if (code=='previous')
            code = 'return localStorage[localStorage.index-1]'
        else if (code.indexOf('localStorage.index')==-1)
        {
            localStorage[localStorage['index']] = code
            localStorage['index']++
        }                
        //console.log('invoking code:' + code)
        try
        {
            jsCode = coffee.compile(code)
            //response = new Function(code).apply(that)
            response = eval(jsCode)
            if (typeof(response) =='undefined')
                executionResult.html('undefined')
            else
                if(typeof(response)=='string')
                    executionResult.html(response)
                else
                    executionResult.html(util.inspect(response))
        }
        catch(error)
        {
            executionResult.html('ERROR: ' + error)
        }        
    })
    button.trigger('click')    

    process.on('uncaughtException', function(err) 
    {
        executionResult.html('UNCAUGHT ERROR: ' + err)
    });

}
