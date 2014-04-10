define(['view/course'], function(course) {

    function create(bin) {
        var elem = document.createElement("ol");
        elem.className = "bin";
        _.each(bin.courses, function(c) {
            var e = course.create(c);
            e.className += " assigned";
            elem.appendChild(e);
        });
        return elem;
    }

    return {
        create: create
    };
});
