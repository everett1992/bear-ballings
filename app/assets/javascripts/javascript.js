/** Shoves a 'load' method into the JSON object that async-GETs data from a same-origin url */
JSON.load = function(url, callback) {
    var request = new XMLHttpRequest();
    request.open("GET", url, true);
    request.responseType = "json";
    request.onreadystatechange = function() {
        if (request.readyState == 4) {
            callback(request.response);
        }
    };
    request.send();
};

/*
function TextTree(v) {
    var value = v;
    var children = {};
    this.add = function(s, v) {
        if (s.length > 1) {
            if (!children[s[0]])
                children[s[0]] = new TextTree(s[0]);
            children[s[0]].add(s.slice(1));
        } else {
            value = s;
        }
    };
    this.find = function(s) {
        if (s.length) {
            if (children[s[0]])
                return children[s[0]].find(s.slice(1));
            return [];
        }
        return _.reduce(children, function(a,b){return a.concat(b.find(""));},
                        value ? [value] : []);
    };
}
*/

(function() {

    var courses;
    var searcher;
    var searchbox;

    function updateList(search) {
        if (!courses)
            return;
        var list = document.getElementById("courses");
        while (list.firstChild)
            list.removeChild(list.firstChild);
        /*
        _.map(_.uniq(searcher.find(search)),
              function(c) {
                  var elem = document.createElement("li");
                  elem.appendChild(document.createTextNode(c.title));
                  list.appendChild(elem);
              });
         */
        for (var i = 0; i < courses.length; i++) {
            var course = courses[i];
            if (course.department.indexOf(search) >= 0 ||
                course.number.toString().indexOf(search) >= 0 ||
                course.title.indexOf(search) >= 0) {
                var elem = document.createElement("li");
                elem.appendChild(document.createTextNode(course.title));
                list.appendChild(elem);
            }
        }
    }
    
    // loads the course data
    //JSON.load("/api/courses", function(data) {
    setTimeout(function() {
        var data = { courses : [ { department : "AES", number : 100, title: "HELLO WORLD" }]};
        if (!data)
            return;
        searchbox = document.getElementById("searchtext");
        // event listener for user input change
        var listenid;
        searchbox.addEventListener("input", function(e) {
            window.clearTimeout(listenid);
            listenid = window.setTimeout(function() {
                updateList(searchbox.value);
            }, 200);
        });
        courses = data.courses;
        /*
        searcher = new TextTree();
        for (var i = 0; i < courses.length; i++) {
            searcher.add(courses[i].department, i);
            searcher.add(courses[i].title, i);
            searcher.add(courses[i].number.toString(), i);
        }
         */
        searchbox.disabled = false;
        updateList(searchbox.value);
    }, 1000);
})();
