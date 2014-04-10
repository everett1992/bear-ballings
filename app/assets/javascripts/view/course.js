define(function() {

    function create(course) {
        var elem = document.createElement("li");
        elem.id = "course_" + course.id;
        elem.className = "course";
        var header = document.createElement("h3");
        var id = document.createElement("span");
        id.className = "courseId";
        id.appendChild(document.createTextNode(course.id));
        //id.appendChild(document.createTextNode(course.department +
        //                                       (course.number < 100 ? '0' : '') + 
        //                                       course.number));
        header.appendChild(id);
        header.appendChild(document.createTextNode(" — "));
        var title = document.createElement("span");
        title.className = "courseTitle";
        title.appendChild(document.createTextNode(course.title));
        header.appendChild(title);
        elem.appendChild(header);
        return elem;
    }

    return {
        create: create
    };
});
