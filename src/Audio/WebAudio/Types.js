"use strict";


exports.nodeConnectImpl = function(source) {
  return function(sink) {
    return function() {
      source.connect(sink);
    };
  };
};

exports.nodeDisconnectImpl = function(source) {
  return function(sink) {
    return function() {
      source.disconnect(sink);
    };
  };
};

exports.unsafeConnectParamImpl = function(source) {
  return function(target) {
    return function(prop) {
      return function() {
        var value = target[prop];
        source.connect(value);
      };
    };
  };
};
