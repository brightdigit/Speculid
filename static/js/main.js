var $ = require("browserify-zepto"),
  checkbox_option = require('../templates/checkbox_option.handlebars'),
  data = require('data'),
  forEach = require('./helpers/forEach');

/*
  http://ivomynttinen.com/blog/the-ios-7-design-cheat-sheet/
  http://iosdesign.ivomynttinen.com/
  https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/IconMatrix.html#//apple_ref/doc/uid/TP40006556-CH27-SW1
  http://ipad.about.com/od/Tablet_Computers_eReaders/a/The-iPad-Comparison-Chart.htm
*/

function id (value) {
  return value.replace(/\s/, "_");
}

function opt (field, value) {
  return {
    "field" : field,
    "label" : value,
    "id" : id(value)
  }
}

function get (value) {
  return (typeof(value) === 'string') ? value : (Object.keys(value)[0]);
}

forEach(data.os, function (key, value) {
  $("#os").append(checkbox_option(opt("os", key)));

});

forEach(data.devices, function (key) {
  $("#devices").append(checkbox_option(opt("dev",get(key))));
});