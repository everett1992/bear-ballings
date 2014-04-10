/** Shoves a 'load' method into the JSON object
 * that async-GETs data from a same-origin url */
JSON.load = function(url, callback) {
    var request = new XMLHttpRequest();
    request.open("GET", url, true);
    request.responseType = "json";
    request.onreadystatechange = function() {
        if (request.readyState == 4) {
            if (request.status == 200)
                callback(request.response);
            else
                callback(undefined);
        }
    };
    request.send();
};

require(['controller'])
