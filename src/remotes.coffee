module.exports = (Model) ->

  Model.convertNullToEmpty = (ctx, cb) ->
    if ctx.result is null
      ctx.result = {}

    cb()

  count:
    accepts: [
      {
        arg: "hashkey",
        description: "Model hashkey"
        http:
          source: "path"
        required: true
        type: "any"
      }
      {
        arg: "where"
        description: "Criteria to match model instances"
        type: "object"
      }
    ]
    accessType: "READ"
    description: "Count instances of the model matched by where from the data source."
    http:
      path: "/:hashkey/count"
      verb: "get"
    returns:
      arg: "count"
      type: "number"

  create:
    accepts: [
      {
        arg: "hashkey",
        description: "Model hashkey"
        http:
          source: "path"
        required: true
        type: "any"
      }
      {
        arg: "data"
        description: "Model instance data"
        http:
          source: "body"
        type: "object"
      }
    ]
    accessType: "WRITE"
    description: "Create a new instance of the model and persist it into the data source."
    http:
      path: "/:hashkey"
      verb: "post"
    returns:
      arg: "data"
      root: true
      type: Model.modelName

  deleteById:
    accepts: [
      {
      arg: "hashkey",
      description: "Model hashkey"
      http:
        source: "path"
      required: true
      type: "any"
      }
      {
      arg: "sortkey",
      description: "Model sortkey"
      http:
        source: "path"
      required: true
      type: "any"
      }
    ]

    accessType: "WRITE"
    aliases: [
      "destroyById"
      "removeById"
    ]
    description: "Delete a model instance by id from the data source."
    http:
      path: "/:hashkey/:sortkey"
      verb: "del"
    returns:
      arg: "count"
      root: true
      type: "object"

  destroyAll:
    accepts: [
      {
        arg: "hashkey",
        description: "Model hashkey"
        http:
          source: "path"
        required: true
        type: "any"
      }
      {
      arg: "where"
      description: "filter.where object"
      type: "object"
      }
    ]
    accessType: "WRITE"
    description: "Delete all matching records."
    http:
      path: "/:hashkey"
      verb: "del"
    returns:
      arg: "count"
      description: "The number of instances deleted"
      root: true
      type: "object"
    shared: false

  exists:
    accepts:[
      {
        arg: "hashkey",
        description: "Model hashkey"
        http:
          source: "path"
        required: true
        type: "any"
      }
      {
        arg: "sortkey",
        description: "Model sortkey"
        http:
          source: "path"
        required: true
        type: "any"
      }
    ]
    accessType: "READ"
    description: "Check whether a model instance exists in the data source."
    http: [
      {
        path: "/:hashkey/:sortkey/exists"
        verb: "get"
      }
      {
        path: "/:hashkey/:sortkey"
        verb: "head"
      }
    ]
    rest:
      after: Model.convertNullToEmpty
    returns:
      arg: "exists"
      type: "boolean"

  findById:
    accepts: [
      {
        arg: "hashkey",
        description: "Model hashkey"
        http:
          source: "path"
        required: true
        type: "any"
      }
      {
        arg: "sortkey",
        description: "Model sortkey"
        http:
          source: "path"
        required: false
        type: "any"
      }
      {
        arg: "filter"
        description: "Filter defining fields and include"
        type: "object"
      }
    ]
    accessType: "READ"
    description: "Find a model instance by id from the data source."
    http: [
      {
        path: "/:hashkey"
        verb: "get"
      }
      {
      path: "/:hashkey/:sortkey"
      verb: "get"
      }
    ]
    rest:
      after: Model.convertNullToEmpty
    returns:
      arg: "data"
      root: true
      type: Model.modelName

  findOne:
    accepts: [
      {
        arg: "hashkey",
        description: "Model hashkey"
        http:
          source: "path"
        required: true
        type: "any"
      }
      {
        arg: "filter"
        description: "Filter defining fields, where, include, order, offset, and limit"
        type: "object"
      }
    ]
    accessType: "READ"
    description: "Find first instance of the model matched by filter from the data source."
    http:
      path: "/:hashkey/findOne"
      verb: "get"
    rest:
      after: Model.convertNullToEmpty
    returns:
      arg: "data"
      root: true
      type: Model.modelName

  patchAttributes:
    isStatic: false
    accepts:[
      {
        arg: "hashkey",
        description: "Model hashkey"
        http:
          source: "path"
        required: true
        type: "any"
      }
      {
        arg: "data"
        description: "An object of model property name/value pairs"
        http:
          source: "body"
        type: "object"
      }
    ]
    accessType: "WRITE"
    aliases: [
      "updateAttributes"
    ]
    description: "Patch attributes for a model instance and persist it into the data source."
    http: [
      {
        path: "/:hashkey"
        verb: "patch"
      }
    ]
    isStatic: false
    returns:
      arg: "data"
      root: true
      type: Model.modelName

  patchOrCreate:
    accepts:[
      {
        arg: "hashkey",
        description: "Model hashkey"
        http:
          source: "path"
        required: true
        type: "any"
      }
      {
        arg: "data"
        description: "Model instance data"
        http:
          source: "body"
        type: "object"
      }
    ]
    accessType: "WRITE"
    aliases: [
      "upsert"
      "updateOrCreate"
    ]
    description: "Patch an existing model instance or insert a new one into the data source."
    http: [
      {
        path: "/:hashkey"
        verb: "patch"
      }
    ]
    returns:
      arg: "data"
      root: true
      type: Model.modelName

  replaceById:
    accepts: [
      {
        arg: "hashkey",
        description: "Model hashkey"
        http:
          source: "path"
        required: true
        type: "any"
      }
      {
        arg: "sortkey",
        description: "Model sortkey"
        http:
          source: "path"
        required: true
        type: "any"
      }
      {
        arg: "data"
        description: "Model instance data"
        http:
          source: "body"
        type: "object"
      }
    ]
    accessType: "WRITE"
    description: "Replace attributes for a model instance and persist it into the data source."
    http: [
      {
        path: "/:hashkey/:sortkey/replace"
        verb: "post"
      }
    ]
    returns:
      arg: "data"
      root: true
      type: Model.modelName

  replaceOrCreate:
    accepts: [
      {
        arg: "hashkey",
        description: "Model hashkey"
        http:
          source: "path"
        required: true
        type: "any"
      }
      {
        arg: "data"
        description: "Model instance data"
        http:
          source: "body"
        type: "object"
      }
    ]
    accessType: "WRITE"
    description: "Replace an existing model instance or insert a new one into the data source."
    http: [
      {
        path: "/:hashkey/replaceOrCreate"
        verb: "post"
      }
    ]
    returns:
      arg: "data"
      root: true
      type: Model.modelName

  updateAll:
    accepts: [
      {
        arg: "hashkey",
        description: "Model hashkey"
        http:
          source: "path"
        required: true
        type: "any"
      }
      {
        arg: "where"
        description: "Criteria to match model instances"
        http:
          source: "query"
        type: "object"
      }
      {
        arg: "data"
        description: "An object of model property name/value pairs"
        http:
          source: "body"
        type: "object"
      }
    ]
    accessType: "WRITE"
    aliases: [
      "update"
    ]
    description: "Update instances of the model matched by where from the data source."
    http:
      path: "/:hashkey/update"
      verb: "post"
    returns:
      arg: "count"
      description: "The number of instances updated"
      root: true
      type: "object"

  findOrCreate:
    description: 'Find else create a new instance of the model and persist it into the data source'
    accepts: [
      {
        arg: "hashkey",
        description: "Model hashkey"
        http:
          source: "path"
        required: true
        type: "any"
      }
      {
        arg: 'data'
        type: 'object'
        required: true
        http:
          source: 'body'
      }
    ]
      
    returns:
      arg: 'data'
      type: Model.modelName
      root: true
    http:
      verb: 'post'
      path: '/:hashkey/findOrCreate'