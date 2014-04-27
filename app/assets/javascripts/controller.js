define(['model', 'view'], function(model, view) {

    model.load(function() {
        view.bins.setBins(model.user.bins);
        view.searchbox.addListener(function(form) {
            view.courses.setCourses(_.filter(model.courses.courses, function(c) {
                var term = form.filter;
                return (c.department.indexOf(term) >= 0 ||
                        c.number.toString().indexOf(term) >= 0 ||
                        (c.department+c.number.toString()).indexOf(term) >= 0 ||
                        c.title.indexOf(term) >= 0);
            }));
        });
        view.courses.setCourses(model.courses.courses);
    });

    view.setBinListener(function(data) {
        console.log(data.course);
        console.log(data.action);
        var message = { _id: data.course };
        if (data.action.type == "bin")
            if (data.action.bin !== model.user.bins.length)
                message.before_bin = data.action.bin;
        else
            message.to_bin = data.action.bin;
        console.log(message);
        JSON.send("/api/user/courses", message, function(response) {
            if (response === undefined)
                alert("CONNECTION FAILURE; REFRESH PAGE!");
            var course = _.findWhere(model.courses.courses, {id: data.course});
            if (data.action.type == "bin") {
                model.user.bins.splice(data.action.bin, 0, {courses: [course]});
            } else {
                model.user.bins[data.action.bin].courses.push(course);
            }
            view.bins.setBins(model.user.bins);
        });
    });

    return {};
});
