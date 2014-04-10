define(['view/course'], function(course) {

    var view = {};

    var elem_courses = document.getElementById("courses");

    view.setCourses = function(courses) {
        while (elem_courses.firstChild)
            elem_courses.removeChild(elem_courses.firstChild);
        _.each(courses, function(c) {
            var elem = course.create(c);
            elem.className += " unassigned";
            elem_courses.appendChild(elem);
        });
    };

    return view;
});
