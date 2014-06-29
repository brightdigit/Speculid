define(['text!../../../../bower_components/namesdatabase/NamesDatabases/first names/all.txt',
  'text!../../../../bower_components/namesdatabase/NamesDatabases/surnames/all.txt'
], function(firstNamesTxt, lastNamesTxt) {
  var firstNames, lastNames;
  return function(firstNamesTxt, lastNamesTxt) {

    function split(text) {
      return text.split('\n');
    }

    function rand(array) {
      return array[Math.floor(Math.random() * array.length)];
    }

    firstNames = firstNames || split(firstNamesTxt);
    lastNames = lastNames || split(lastNamesTxt);

    return function() {
      return [rand(firstNames), rand(lastNames)];
    };
  }(firstNamesTxt, lastNamesTxt);
});
