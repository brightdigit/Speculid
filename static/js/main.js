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
  } else if (value) {
    return value + "px";
  }
}

function highlight (e) {
  $('td').removeClass("hover");
  $('tr').removeClass("hover");
  var $td = $(this);
  var $tr = $td.parent('tr');
  if (e.type="mouseover" && $td.index() > 0) {
    $td.addClass("hover");
    $tr.addClass("hover");
  }
  
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
  for (var index = 0; index < devices.length; index++) {
    table.append("<colgroup></colgroup>");
  }
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
          val = val || "";
          if (!sizes[val]) {
            sizes[val] = 1;
          } else {
            sizes[val]++;
          }
        });
        console.log(sizes);
      return $("<tr><td>" + name + "</td></tr>").append(
        $.map(Object.keys(sizes), function (device) {
          if (device) {
            return $('<td colspan="' + sizes[device] + '">'+device+"</td>");
          } else {
            return $('<td class="empty" colspan="' + sizes[device] + '"></td>');
          }
        })
      );//.toggleClass('inactive', data.assets.indexOf(name) < 0);
    });
  tbody.append(rows);
  $('#data table').remove();
  $('#data').append(table);
  table.on('mouseover mouseleave', 'td,th', highlight);
  /*
  table.on('click', 'td:first-child a', function (e) {
    $(this).closest('tr').toggleClass('inactive');
    return false;
  });
*/
}

var $os = $("#os");
forEach(data.os, function (key, value) {
  $(checkbox_option(opt("os", key))).appendTo($os);
});

console.log(data.devices);
forEach(data.devices, function (key) {
  $("#devices").append(checkbox_option(opt("devices",get(key))));
});

$('#menu input').on('change', updateUI);

updateUI();

$('.minimize,.expand').empty().on('click', function () {
  var $this = $(this);
  var inHeader = !!$this.parents('header').length;
  var minimized = ($this.hasClass('minimize') ? inHeader : !inHeader);
  $('header').toggleClass('minimized',minimized );
  var expandButton = $('.expand');
  var minimizeButton = $('.minimize');
  minimizeButton.addClass('expand').removeClass('minimize').attr('title', minimized ?
   'Expand the header bar.' : 'Minimize the header bar');
  expandButton.addClass('minimize').removeClass('expand').attr('title',minimized ?
   'Expand the header bar.' : 'Minimize the header bar');
});

$('#menu').on('mouseover mouseleave', 'label', function (e) {
  $(this).toggleClass('hover', e.type === "mouseover");
});

$(window).on('scroll', function (e) {
  var top = (window.pageYOffset !== undefined) ? window.pageYOffset : (document.documentElement || document.body.parentNode || document.body).scrollTop;
  $('header').toggleClass('filter-hidden',  top > $('header').height());
});

$('#filter-expand').on('click', function (e) {
  if ($('header').hasClass('filter-hidden')) {
    window.scrollTo(0, 0);
  }
});
