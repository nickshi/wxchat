var server = require('http').createServer()
  , url = require('url')
  , WebSocketServer = require('ws').Server
  , wss = new WebSocketServer({ server: server })
  , express = require('express')
  , app = express()
  , port = 4080
  , db = require('./db');


db.connect(db.MODE_PRODUCTION, function(err) {

  if (err) {
    console.log('Unable to connect to MySQL.')
    process.exit(1)
  } 
  else
  {
    wss.on('connection', function connection(ws) {
        var location = url.parse(ws.upgradeReq.url, true);
        // you might use location.query.access_token to authenticate or share sessions 
        // or ws.upgradeReq.headers.cookie (see http://stackoverflow.com/a/16395220/151312) 
        console.log('new connection')
        ws.on('message', function incoming(message) {
          console.log('received: %s', message);
        });
       
        ws.send('something');
    });
 
    server.on('request', app);
    server.listen(port, function () { console.log('Listening on ' + server.address().port) });
  }


});


var user = require('./models/user');

user.getAll(function(err, rows) {
    console.log("rows ", rows)
});

