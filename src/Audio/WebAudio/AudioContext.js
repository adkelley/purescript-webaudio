/* jshint maxparams: false */
/* global exports, XMLHttpRequest */
"use strict";

// module Audio.WebAudio.AudioContext

exports.resume = function(ctx) {
  return function() {
    return ctx.resume();
  };
};

exports.suspend = function(ctx) {
  return function() {
    return ctx.suspend();
  };
};

exports.stateImpl = function(ctx) {
  return function() {
    return ctx.state;
  };
};


exports.makeAudioContext = function() {
  return new (window.AudioContext || window.webkitAudioContext)();
};


exports.createOscillator = function(ctx) {
  return function() {
    return ctx.createOscillator();
  };
};



exports.createGain = function(ctx) {
  return function() {
    return ctx.createGain();
  };
};

exports.createMediaElementSource = function(ctx) {
  return function(elt) {
    return function() {
      return ctx.createMediaElementSource(elt);
    };
  };
};

exports.currentTime = function(cx) {
  return function() {
    return cx.currentTime;
  };
};

exports.sampleRate = function(cx) {
  return function() {
    return cx.sampleRate;
  };
};

exports.decodeAudioData = function(cx) {
  return function(audioData) {
    return function(success) {
      return function(failure) {
        return function() {
          cx.decodeAudioData(audioData,
            function(data) {
              success(data)();
            },
            function(e) {
              failure(e.err);
            });
        };
      };
    };
  };
};

exports.createBufferSource = function(cx) {
  return function() {
    return cx.createBufferSource();
  };
};



exports.connect = function(_) {
  return function(_) {
    return function(source) {
      return function(sink) {
        return function() {
          source.connect(sink);
        };
      };
    };
  };
};


exports.disconnect = function(_) {
  return function(_) {
    return function(source) {
      return function(sink) {
        return function() {
          source.disconnect(sink);
        };
      };
    };
  };
};
