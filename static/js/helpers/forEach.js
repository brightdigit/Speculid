module.exports = function (obj, cb) {
  if (Array.isArray(obj)) {
    var i = 0,
      len = obj.length;
    for (; i < len; i++) {
      cb(obj[i], i, obj);
    }
  } else {
    Object.keys(obj).forEach(function (key, index, array) {
      cb(key, obj[key], index, obj, array);  
    });
  }
};