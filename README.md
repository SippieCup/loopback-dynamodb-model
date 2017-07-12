# loopback-Dynamo-model

Loopback Dynamo Model

* npm install loopback-dynamo-model --save
* within server/server.js add
`require('loopback-dynamo-model')(app)`

yourmodel.json

```
name: "YourModel"
base: "DynamoModel"

defaultMethods: [ 'find', 'create' ] // only enable find and create endpoint
defaultMethods: 'all' // enable all default endpoints
defaultMethods: 'none' // dont expose any endpoints
defaultMethods: 'extended' // enable all default endpoints + findOrCreate endpoint
```

License: MIT
