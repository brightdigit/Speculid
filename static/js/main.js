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

var images = {},
  resolutions = {};

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

function updateUI (e) {
  console.log('updateUI')
  var type = $(this).closest('ol').attr('id');

  if (type === "os") {
    var oses = $.map($('[name="os"]:checked'), function (item) {return $(item).val(); });
    var devices = oses.reduce(function (memo, value) {
      return data.os[value].reduce(function (memo, value) {
        memo[value] = true;
        return memo;

      }, memo);
    }, {});
    $('input[name="devices"]').each(function () {
      $(this).prop('disabled', !devices[$(this).val()]);
      $(this).prop('checked', $(this).prop('checked') && devices[$(this).val()]);
    });
  }


}

var $os = $("#os");
forEach(data.os, function (key, value) {
  $(checkbox_option(opt("os", key))).appendTo($os);
});

forEach(data.devices, function (key) {
  $("#devices").append(checkbox_option(opt("devices",get(key))));
});

$('#menu input').on('change', updateUI);


