var db = require('../db.js')

exports.getAll = function(done) {
	db.get().query('SELECT * FROM user', function(err, rows) {
		if (err) return done(err);

		done(null, rows);
	})

};

exports.getUser = function(userID, done) {
	db.get().query('SELECT * FROM user WHERE user_id = ?', userID, function(err, rows) {
		if(err) return done(err);

		done(null, rows);
	});
};