/** Shoves a 'load' method into the JSON object that async-GETs data from a same-origin url */
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

    var state;

    var courses;
    var searcher;
    var bins;

    var v_bins;
    var v_searchbox;
    var v_courses;

    var v_active;

    function buildElementBin() {
        var elem = document.createElement("ol");
        elem.className = "bin";
        return elem;
    }
    function buildElementCourse(course) {
        var elem = document.createElement("li");
        elem.className = "course";
        var header = document.createElement("h3");
        var id = document.createElement("span");
        id.className = "courseId";
        id.appendChild(document.createTextNode(course.department +
                                               (course.number < 100 ? '0' : '') + 
                                               course.number));
        header.appendChild(id);
        header.appendChild(document.createTextNode(" — "));
        var title = document.createElement("span");
        title.className = "courseTitle";
        title.appendChild(document.createTextNode(course.title));
        header.appendChild(title);
        elem.appendChild(header);
        elem.onmousedown = function(e) {
            if (e.button != 0)
                return;
            v_active = elem;
            document.onmousemove = mousemove;
            document.onmouseup = mouseup;
            if (elem.setCapture) { elem.setCapture(); }
            mousedown(e);
        };
        return elem;
    }

    function mousedown(e) {
        e.preventDefault();
        v_active.style.backgroundColor = "yellow";
        //document.body.style.cursor = "move";
    }

    function mousemove(e) {
        if (!v_active)
            return;
        e.preventDefault();
        var type = (v_active.className.indexOf("unassigned") < 0 ? "assigned" : "unassigned");
        if (type !== "unassigned")
            return;
        var bins_b = document.getElementById("bins").getBoundingClientRect();
        if (e.pageX - bins_b.left < 0 || bins_b.right - e.pageX < 0 ||
            e.pageY - bins_b.top < 0 || bins_b.bottom - e.pageY < 0)
            return;
        var bin = _.findWhere(bins, function(b) {
            return (e.pageX - bins_b.left < 0 || bins_b.right - e.pageX < 0 ||
                    e.pageY - bins_b.top < 0 || bins_b.bottom - e.pageY < 0);
        });
        console.log((e.clientY - bins_b.top), (e.clientX - bins_b.left));
        console.log((e.pageY - bins_b.top), (e.pageX - bins_b.left));
    }

    function mouseup(e) {
        if (e.button != 0)
            return;
        if (!v_active)
            return;
        e.preventDefault();
        document.onmousemove = null;
        document.onmouseup = null;
        v_active.style.backgroundColor = "";
        if (v_active.releaseCapture) { v_active.releaseCapture(); }
        v_active = undefined;
        //document.body.style.cursor = "";
    }

    function updateCourses(search) {
        if (!courses)
            return;
        while (v_courses.firstChild)
            v_courses.removeChild(v_courses.firstChild);
        for (var i = 0; i < courses.length; i++) {
            var course = courses[i];
            if (course.department.indexOf(search) >= 0 ||
                course.number.toString().indexOf(search) >= 0 ||
                course.title.indexOf(search) >= 0) {
                var elem = buildElementCourse(course);
                elem.className += " unassigned";
                v_courses.appendChild(elem);
            }
        }
    }

    function loadUser(callback) {
        JSON.load("/api/user/courses", function(data) {
            if (!data) {
                alert("ERROR LOADING DATA");
                return;
            }
            bins = _.map(data.bins, function(b) {
                return { courses: b.bin.courses,
                         v_bin: buildElementBin() };
             });
            v_bins = document.getElementById("bins");
            while (v_bins.firstChild)
                v_bins.removeChild(v_bins.firstChild);
            _.each(bins, function(b) {
                v_bins.appendChild(b.v_bin);
                _.each(b.courses, function(c) {
                    var elem = buildElementCourse(c);
                    elem.className += " assigned";
                    b.v_bin.appendChild(elem);
                });
            });
            callback();
        });
    }
    function loadCourses(callback) {
        // loads the course data
        //setTimeout(function() {
        JSON.load("/api/courses", function(data) {
            //var data = { courses : [ { department : "AES", number : 100, title: "HELLO WORLD" }]};
            if (!data) {
                alert("ERROR LOADING DATA");
                return;
            }
            courses = data.courses;
            /*
             searcher = new TextTree();
             for (var i = 0; i < courses.length; i++) {
             searcher.add(courses[i].department, i);
             searcher.add(courses[i].title, i);
             searcher.add(courses[i].number.toString(), i);
             }
             */
            callback();
        }, 1000);
    }

    function loadDocument(callback) {
        // store handles to the document
        v_searchbox = document.getElementById("searchtext");
        v_courses = document.getElementById("courses");
        // listen on the search box for input
        v_searchbox.addEventListener("input", _.debounce(function(e) {
            updateCourses(v_searchbox.value);
        }, 200));
        v_searchbox.disabled = false;
        // update the course list with the default search value
        updateCourses(v_searchbox.value);
        if (callback)
            callback();
    }

    function load() {
        state = {};
        loadUser(function() {
            loadCourses(function() {
                loadDocument();
            });
        });
    }

    load();

})();
