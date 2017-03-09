// Generated by CoffeeScript 1.12.4
(function() {
  module.exports = function(Model, options) {
    var customMethods, defaultMethods, methods, ref, setRemoting;
    ref = Model.definition.settings, defaultMethods = ref.defaultMethods, methods = ref.methods;
    customMethods = Object.keys(methods || {});
    setRemoting = function(scope, methodName, options) {
      var fn;
      fn = scope.prototype[methodName] || scope[methodName];
      fn._delegate = true;
      scope.remoteMethod(methodName, options);
    };
    Model.once('attached', function(server) {
      var defaultRemotes, extendedKeys, methodKeys, scope, selectedMethods;
      scope = server.models[Model.modelName];
      defaultRemotes = require('./remotes')(Model);
      methodKeys = Object.keys(defaultRemotes);
      selectedMethods = methodKeys;
      if (defaultMethods === 'none') {
        selectedMethods = [];
      }
      extendedKeys = defaultMethods === 'extended';
      if (Array.isArray(defaultMethods)) {
        selectedMethods = defaultMethods.filter(function(defaultMethod) {
          return methodKeys.indexOf(defaultMethod) > -1;
        });
      }
      return selectedMethods.forEach(function(method) {
        if (customMethods.indexOf(method) > -1) {
          return;
        }
        if (method === 'findOrCreate' && !extendedKeys) {
          return;
        }
        options = defaultRemotes[method];
        options.isStatic = options.isStatic || true;
        return setRemoting(scope, method, options);
      });
    });
  };

}).call(this);
