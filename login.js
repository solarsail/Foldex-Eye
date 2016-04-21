WorkerScript.onMessage = function(message) {
    login(message.username, message.password, function(code, response) {
        WorkerScript.sendMessage({ 'status': code, 'reply': response })
    });
}

function login(user, pass, cb) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
            //print(xhr.status);
        } else if(xhr.readyState === XMLHttpRequest.DONE) {
            var object = JSON.parse(xhr.responseText.toString());
            cb(xhr.status, object)
        }
    }
    xhr.open("POST", "http://192.168.1.41:8893/login");
    xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    xhr.send(JSON.stringify({username:user, password:pass}));
}
