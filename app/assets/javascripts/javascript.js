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

    var courses;
    var searcher;
    var bins;

    var v_searchbox;
    var v_courses;
    var v_bins;

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
        id.appendChild(document.createTextNode(course.department + course.number));
        header.appendChild(id);
        header.appendChild(document.createTextNode(" — "));
        var title = document.createElement("span");
        title.className = "courseTitle";
        title.appendChild(document.createTextNode(course.title));
        header.appendChild(title);
        elem.appendChild(header);
        return elem;
    }

    function updateCourses(search) {
        if (!courses)
            return;
        while (v_courses.firstChild)
            v_courses.removeChild(v_courses.firstChild);
        /*
         _.map(_.uniq(searcher.find(search)),
         function(c) {
         var elem = document.createElement("li");
         elem.appendChild(document.createTextNode(c.title));
         v_courses.appendChild(elem);
         });
         */
        for (var i = 0; i < courses.length; i++) {
            var course = courses[i];
            if (course.department.indexOf(search) >= 0 ||
                course.number.toString().indexOf(search) >= 0 ||
                course.title.indexOf(search) >= 0) {
                v_courses.appendChild(buildElementCourse(course));
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
                    b.v_bin.appendChild(buildElementCourse(c));
                });
            });
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
            v_searchbox = document.getElementById("searchtext");
            v_courses = document.getElementById("courses");
            // event listener for user input change
            var listenid;
            v_searchbox.addEventListener("input", function(e) {
                window.clearTimeout(listenid);
                listenid = window.setTimeout(function() {
                    updateCourses(v_searchbox.value);
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
            v_searchbox.disabled = false;
            updateCourses(v_searchbox.value);
        }, 1000);
    }

    loadUser();
    loadCourses();

})();
