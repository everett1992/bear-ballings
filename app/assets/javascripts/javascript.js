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


require.config({
    baseUrl: "/assets"
});

require(["controller"], function(controller) {
});


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
/*
(function() {

    var model;
    var view;

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

    function updateUserBins(bins) {
        if (!bins)
            return;
        while (view.bins.firstChild)
            view.bins.removeChild(view.bins.firstChild);
        _.each(bins, function(b) {
            var binview = buildElementBin();
            view.bins.appendChild(binview);
            _.each(b.courses, function(c) {
                var elem = buildElementCourse(c);
                elem.className += " assigned";
                binview.appendChild(elem);
            });
        });
    }

    function updateCourses(courses, search) {
        if (!courses || typeof search !== "string")
            return;
        while (view.courses.firstChild)
            view.courses.removeChild(view.courses.firstChild);
        var cs = _.filter(courses, function(c) {
            return (c.department.indexOf(search) >= 0 ||
                    c.number.toString().indexOf(search) >= 0 ||
                    (c.department+c.number.toString()).indexOf(search) >= 0 ||
                    c.title.indexOf(search) >= 0);
        });
        _.each(cs, function(c) {
            var elem = buildElementCourse(c);
            elem.className += " unassigned";
            view.courses.appendChild(elem);
        });
    }

    function loadUser(callback) {
        JSON.load("/api/user/courses", function(data) {
            if (!data) {
                alert("ERROR LOADING DATA");
                return;
            }
            model.user = {};
            model.user.bins = _.map(data.bins, function(b) {
                return { courses: b.bin.courses };
            });
            updateUserBins(model.user.bins);
            if (callback)
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
            model.courses = data.courses;
            if (callback)
                callback();
        }, 1000);
    }

    function loadView(callback) {
        view.searchbox = document.getElementById("searchtext");
        view.courses = document.getElementById("courses");
        view.bins = document.getElementById("bins");
        view.selected = null;
        if (callback)
            callback();
    }

    function load() {
        model = {};
        view = {};
        loadView(function () {
            loadUser(function() {
                loadCourses(function() {
                    // listen on the search box for input
                    view.searchbox.addEventListener("input", _.debounce(function(e) {
                        updateCourses(model.courses, view.searchbox.value);
                    }, 200));
                    view.searchbox.disabled = false;
                    // update the course list with the default search value
                    updateCourses(model.courses, view.searchbox.value);
                });
            });
        });
    }

    load();

})();
*/
