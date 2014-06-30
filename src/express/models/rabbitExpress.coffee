rabbit = require('rabbit.js')

module.exports =
  plugin: (schema, options) ->
    schema.post "save", (doc) ->
      doc.type = "asdas"
      doc.your_mum = "asdasd"
      context = rabbit.createContext();
      context.on 'ready',  () ->
        pub = context.socket('PUB', {routing: 'topic'})
        pub.connect "lunch", () ->
          pub.write(JSON.stringify({ type: options.type, data: doc}), 'utf8')

  push: (lunchId, type, data) =>
    console.log "pushing to lunch#{lunchId}"
    context = rabbit.createContext();
    context.on 'ready',  () ->
      pub = context.socket('PUB', {routing: 'topic'})
      pub.connect "lunch", () ->
        pub.publish("lunch#{lunchId}", JSON.stringify({ type: type, data: data}), 'utf8')
