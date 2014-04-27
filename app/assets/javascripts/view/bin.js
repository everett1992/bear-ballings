define(['view/course'], function(course) {

    function create(bin) {
        var elem = document.createElement("ol");
        //elem.className = "bin";
        _.each(bin.courses, function(c) {
            var e = course.create(c);
            e.className += " assigned";
            elem.appendChild(e);
        });
        var li = document.createElement("li");
        li.className = "bin";
        li.appendChild(elem);
        return li;
    }

    return {
        create: create
    };
});
