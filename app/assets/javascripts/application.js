/** Shoves a 'load' method into the JSON object
 * that async-GETs data from a same-origin url */
JSON.load = function(url, callback) {
    var request = new XMLHttpRequest();
    request.open("GET", url, true);
    request.responseType = "json";
    request.onreadystatechange = function() {
        if (request.readyState == 4) {
            console.log(request.status);
            if (request.status == 200)
                callback(request.response);
            else
                callback(undefined);
        }
    };
    request.send();
};

JSON.send = function(url, type, json, callback) {
    var request = new XMLHttpRequest();
    request.open(type, url, true);
    request.setRequestHeader("Content-Type", "application/json");
    request.onreadystatechange = function() {
        if (request.readyState == 4) {
            if (request.status >= 200 && request.status < 300)
                callback(json);
            else {
                console.log(request.response);
                callback(request.status);
            }
        }
    };
    request.send(JSON.stringify(json));
};

require(['controller']);
