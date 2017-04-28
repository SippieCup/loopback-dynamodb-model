// Generated by CoffeeScript 1.12.5
(function() {
  var mixin;

  mixin = require('./mixin');

  module.exports = function(app) {
    var DynamoModel, Model, addMethods, aliasMethods, instanceMethods, registry, staticMethods, throwNotAttached;
    registry = app.registry;
    Model = registry.getModel('PersistedModel');
    DynamoModel = Model.extend('DynamoModel');
    registry.modelBuilder.mixins.define('DynamoRemoting', mixin);
    throwNotAttached = function(modelName, methodName) {
      throw new Error('Cannot call ' + modelName + '.' + methodName + '().' + ' The ' + methodName + ' method has not been setup.' + ' The DynamoModel has not been correctly attached to a DataSource!');
    };
    staticMethods = ['count', 'create', 'deleteById', 'destroyAll', 'exists', 'find', 'findById', 'findOne', 'findOrCreate', 'replaceById', 'replaceOrCreate', 'updateAll', 'updateOrCreate'];
    instanceMethods = ['isNewRecord', 'destroy', 'remove', 'delete', 'updateAttribute', 'updateAttributes', 'patchAttributes', 'replaceAttributes', 'reload'];
    addMethods = function(methods, baseProperty) {
      methods.forEach(function(method) {
        baseProperty[method] = function() {
          throwNotAttached(this.modelName, method);
        };
      });
    };
    addMethods(staticMethods, DynamoModel);
    addMethods(instanceMethods, DynamoModel.prototype);
    aliasMethods = {
      destroyAll: ['remove', 'deleteAll'],
      destroyById: ['removeById', 'deleteById'],
      updateAll: ['update'],
      updateOrCreate: ['patchOrCreate', 'upsert']
    };
    Object.keys(aliasMethods).forEach(function(alias) {
      var methods;
      methods = aliasMethods[alias];
      return methods.forEach(function(method) {
        return DynamoModel[method] = DynamoModel[alias];
      });
    });
    DynamoModel.setup = function() {
      Model.setup.call(this);
      DynamoModel = this;
      DynamoModel.mixin('DynamoRemoting');
      return DynamoModel;
    };
    DynamoModel.getIdName = function() {
      var ds;
      Model = this;
      ds = Model.getDataSource();
      if (ds.idName) {
        return ds.idName(Model.modelName);
      } else {
        return 'id';
      }
    };
    DynamoModel.prototype.save = function(options, callback) {
      var inst, save;
      if (options == null) {
        options = {};
      }
      if (callback == null) {
        callback = function() {};
      }
      if (typeof options === 'function') {
        return this.save({}, options);
      }
      Model = this.constructor;
      save = function() {
        var data, id;
        id = inst.getId();
        if (!id) {
          return Model.create(inst, callback);
        }
        data = inst.toObject();
        return Model.upsert(inst, function(err) {
          inst._initProperties(data);
          return callback(err, inst);
        });
      };
      options.validate = options.validate || true;
      inst = this;
      if (!options.validate) {
        return save();
      }
      inst.isValid(function(valid) {
        var err;
        if (valid) {
          save();
        } else {
          err = new Model.ValidationError(inst);
          callback(err, inst);
        }
      });
    };
    DynamoModel.prototype.getIdNames = function() {
      return this.constructor.getIdNames();
    };
    DynamoModel.prototype.getId = function() {
      return this[this.getIdNames()];
    };
    DynamoModel.prototype.setId = function(val) {
      var idNames;
      idNames = this.getIdNames();
      this[idNames[0]] = val[0];
      if (val[1]) {
        this[idNames[1]] = val[1];
      }
    };
    DynamoModel.setup();
    return DynamoModel;
  };

}).call(this);
