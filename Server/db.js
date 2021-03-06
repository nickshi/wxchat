var mysql = require('mysql');
var async = require('async');

var PRODUCTION_DB = 'test';
var TEST_DB = 'test';


module.exports.MODE_TEST = 'mode_test';
module.exports.MODE_PRODUCTION = 'mode_production';

var state = {
	pool: null,
	mode: null,
}

module.exports.connect = function(mode, done) {
	state.pool = mysql.createPool({
		host:'localhost',
		port: 3307,
		user:'root',
		password:'',
		database: mode == exports.MODE_PRODUCTION ? PRODUCTION_DB : TEST_DB,
	});

	state.mode = mode
	done()
}

module.exports.get = function() {
	return state.pool;
}

module.exports.fixtures = function(data, done) {
	var pool = state.pool;

	if (!pool) return done(new Error('Missing database connection.'));

	var names = Object.keys(data.tables);
	async.each(names, function(name, cb) {
		async.each(data.tables[name], function(row, cb) {
				var keys = Object.keys(row);
				var values = keys.map(function(key) { return "'" + row[key] + "'";});
				pool.query('INSERT INTO ' + name + ' ( ' + keys.join(',') + ') VALUES ( ' + values.join(',') + ')', cb);
			}, cb);
		}, done);
}

module.exports.drop = function(tables, done) {
	var pool = state.pool;
	if (!pool) return done(new Error('Missing database connection.'));

	async.each(tables, function(name, cb) {
		pool.query('DELETE * FROM ' + name, cb);
	}, done);
}