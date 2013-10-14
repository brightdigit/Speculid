var master = require('./_master'),
  indexer = require('../libs/indexer');

module.exports = indexer(__dirname, master.construct);
