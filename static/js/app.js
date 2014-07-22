define(['zepto', 'templates'], function ($, templates) {
  return {
    start: function () {
      $('main').html(templates.home);
    }
  };
});