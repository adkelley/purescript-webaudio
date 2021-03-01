/* jshint maxparams: false */
/* global exports, XMLHttpRequest */
"use strict";

// module Audio.WebAudio.AudioBufferSourceNode

exports.setBuffer = function(buf) {
  return function(src) {
    return function() {
      src.buffer = buf;
    };
  };
};

exports.startBufferSourceFn4 = function(when) {
  return function(offset) {
    return function(duration) {
      return function(src) {
        return function() {
          src.start(when, offset, duration);
        };
      }
    }
  };
};

exports.startBufferSourceFn3 = function(when) {
  return function(offset) {
    return function(src) {
      return function() {
        src.start(when, offset);
      };
    }
  };
};

exports.startBufferSourceFn2 = function(when) {
  return function(src) {
    return function() {
      src.start(when);
    };
  };
};

exports.startBufferSourceFn1 = function(src) {
  return function() {
    src.start();
  };
};


exports.stopBufferSource = function(when) {
  return function(src) {
    return function() {
      src.stop(when);
    };
  };
};

exports.detune = function(src) {
  return function() {
    return src.detune;
  };
};

exports.playbackRate = function(src) {
  return function() {
    return src.playbackRate;
  };
};

exports.onended = function(src) {
  return function(fn) {
    return function() {
      src.onended = function(event) {
        fn(event)();
      };
    };
  };
};
