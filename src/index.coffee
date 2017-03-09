mixin = require './mixin'

module.exports = (app) ->
  registry = app.registry

  Model = registry.getModel 'Model'
  DynamoModel = Model.extend 'DynamoModel'

  registry.modelBuilder.mixins.define 'DynamoRemoting', mixin

  throwNotAttached = (modelName, methodName) ->
    throw new Error('Cannot call ' + modelName + '.' + methodName + '().' + ' The ' + methodName + ' method has not been setup.' + ' The DynamoModel has not been correctly attached to a DataSource!')
    return

  staticMethods = [
    'count'
    'create'
    'deleteById'
    'destroyAll'
    'exists'
    'find'
    'findById'
    'findOne'
    'findOrCreate'
    'replaceById'
    'replaceOrCreate'
    'updateAll'
    'updateOrCreate'
  ]

  instanceMethods = [
    'isNewRecord'
    'destroy'
    'remove'
    'delete'
    'updateAttribute'
    'updateAttributes'
    'patchAttributes'
    'replaceAttributes'
    'reload'
  ]

  addMethods = (methods, baseProperty) ->
    methods.forEach (method) ->
      baseProperty[method] = ->
        throwNotAttached @modelName, method
        return
      return
    return

  addMethods staticMethods, DynamoModel
  addMethods instanceMethods, DynamoModel.prototype

  aliasMethods =
    destroyAll: [ 'remove', 'deleteAll' ]
    destroyById: [ 'removeById', 'deleteById' ]
    updateAll: [ 'update' ]
    updateOrCreate: [ 'patchOrCreate', 'upsert' ]

  Object.keys(aliasMethods).forEach (alias) ->
    methods = aliasMethods[alias]

    methods.forEach (method) ->
      DynamoModel[method] = DynamoModel[alias]

  DynamoModel.setup = ->
    Model.setup.call this

    DynamoModel = this
    DynamoModel.mixin 'DynamoRemoting'

    DynamoModel

  DynamoModel.getIdName = ->
    Model = this

    ds = Model.getDataSource()

    if ds.idName
      ds.idName Model.modelName
    else 'id'

  DynamoModel::save = (options = {}, callback = ->) ->
    if typeof options is 'function'
      return @save {}, options

    Model = @constructor

    save = ->
      id = inst.getId()

      if not id
        return Model.create inst, callback

      data = inst.toObject()

      Model.upsert inst, (err) ->
        inst._initProperties data
        callback err, inst

    options.validate = options.validate or true

    inst = this

    if not options.validate
      return save()

    inst.isValid (valid) ->
      if valid
        save()
      else
        err = new Model.ValidationError inst

        callback err, inst

      return
    return

  DynamoModel::getIdNames = ->
    @constructor.getIdNames()

  DynamoModel::getId = ->
    @[@getIdNames()]

  DynamoModel::setId = (val) ->
    idNames = @getIdNames()
    @[idNames[0]] = val[0]
    if val[1]
      @[idNames[1]] = val[1]
    return

  DynamoModel.setup()

  DynamoModel

