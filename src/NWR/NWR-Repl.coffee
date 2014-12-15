

  repl: (callback)=>
    replServer = @.repl_Me ()=>
    replServer.context.nwr = @
    callback (replServer) if callback
