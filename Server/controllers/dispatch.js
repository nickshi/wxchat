

var handlers = {};

module.exports.dispatch = function(message, socket){

	var json = JSON.parse(message);
	
	var msgID = json.msgID;
	
	var cb = handlers[msgID];
	
	console.log("handlers ", handlers)
	if(cb){
		var jsonStr = cb();
		socket.send(jsonStr);
	} 
}

module.exports.addHandler = function(msgID, cb) {
	handlers[msgID] = cb;

}
