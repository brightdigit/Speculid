var uuid = require('node-uuid');

var id = new Buffer(uuid.parse(uuid.v4()));
console.log(id);
console.log(id.length);
console.log(id.toString('base64'));
console.log(id.toString('hex'));
console.log(id.toString('ascii'));

var values = [];
for (var index = 0; index < 64; index++) {
  if (index < 10) {
    values.push(index + 48); 
  } else if (index < 10 + 26) {
    values.push(index + 55);
  } else {
    values.push(index + 59);
  } 
}
console.log(String.fromCharCode.apply(undefined, values));