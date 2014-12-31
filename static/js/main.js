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

function formatCellText (value) {
  if (Array.isArray(value)) {
    return value[0] + "px x " + value[1] + "px"
  } else {
    return value + "px";
  }
}

function highlight (e) {
  var $td = $(this);
  var $tr = $td.parent('tr');
  $('td').remove($td).removeClass("hover");
  $td.addClass("hover");
  $('tr').remove($tr).removeClass("hover");
  $tr.addClass("hover");
  $('')
}

function updateUI (e) {

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
      $(this).prop('checked',  devices[$(this).val()]);
    });
  }

  var devices = $('input[name="devices"]:checked').map(function () {return $(this).val();});
  var table = $('<table></table>');
  
  $("<thead></thead>").appendTo(table).append($("<tr></tr>").append($.map(devices, function (device) {
    return $("<th>"+device+"</th>");
  })).prepend("<th></th>"));
  var tbody = $("<tbody></tbody>").appendTo(table);
  $("<tr></tr>").append($.map(devices, function (device){
    return $("<td>" + formatCellText(data.display[device]) + "</td>");
  })).prepend("<td>Display Resolution</td>").appendTo(tbody);
  var rows = $.map(Object.keys(data.images),function (name) {
    var sizes = {};
        $.each(devices, function (device){
          var val = formatCellText(data.images[name][this]);
          if (!sizes[val]) {
            sizes[val] = 1;
          } else {
            sizes[val]++;
          }
        });
      return $("<tr><td>" + name + "</td></tr>").append(
        
        $.map(Object.keys(sizes), function (device) {
          return $('<td colspan="' + sizes[device] + '">'+device+"</td>");
        })
      );
    });
  tbody.append(rows);
  $('#data').empty();
  $('#data').append(table);
  //table.find("td").on('mouseover', highlight);
}

var $os = $("#os");
forEach(data.os, function (key, value) {
  $(checkbox_option(opt("os", key))).appendTo($os);
});

forEach(data.devices, function (key) {
  $("#devices").append(checkbox_option(opt("devices",get(key))));
});

$('#menu input').on('change', updateUI);

updateUI();


