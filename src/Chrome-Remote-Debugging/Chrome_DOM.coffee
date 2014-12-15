dom_Document: (callback)=>
  @_chrome.DOM.getDocument (err, data)->
    callback(data.root)

dom_Html: (nodeId,callback)=>
  @_chrome.DOM.getOuterHTML {nodeId:nodeId}, (err, data)=>
    value = data.outerHTML
    $ = if (value) then cheerio.load(value) else null
    callback {nodeId:nodeId, html:value, $:$}

dom_Find: (selector, callback)=>
  @dom_Document (document)=>
    @_chrome.DOM.querySelector {nodeId:document.nodeId, selector:selector}, (err, result)=>
      nodeId = result.nodeId
      @dom_Html nodeId, callback

dom_Find_All: (selector, callback)=>
  @dom_Document (document)=>
    @_chrome.DOM.querySelectorAll {nodeId:document.nodeId, selector:selector}, (err, results)=>
      all_Data = []
      map_NodeId_Html = (nodeId, next) =>
        @dom_Html nodeId, (data)=>
          all_Data.push(data)
          next()

      async.each results.nodeIds, map_NodeId_Html, ()-> callback(all_Data)

url: (callback)=>
  @eval_Script 'window.location.href', callback

    html: (callback)=>
    @eval_Script 'document.documentElement.outerHTML', (value)->
      $ = if (value) then cheerio.load(value) else null
      callback(value, $)

        dom_Find     : (selector,callback)=>
      @chrome.dom_Find selector, (data)->
        callback(data.$)

  field: (selector, value, callback)=>
    if value instanceof Function
      callback = value
      value = null
      @chrome.dom_Find "input#{selector}", (data)->
        attributes = data.$('input').attr()
        callback(attributes)
    else
      "need to set the field".log()
      callback()


  click: (text, callback)->
    code = "elements = document.documentElement.querySelectorAll('a');
            for(var i=0; i< elements.length; i++)
              if(elements[i].innerText == '#{text}')
                elements[i].click();"
    @chrome.eval_Script code, (err,data)=>
      @wait_For_Complete =>
        @open_Delay.wait =>
          @html callback

  html: (callback)=>
    @chrome.html (html,$) =>
      callback(html,@add_Cheerio_Helpers($))


  add_Cheerio_Helpers: ($)=>
    $.body = $('body').html()
    $.title = $('title').html()
    $.links = ($.html(link) for link in $('a'))
    $