define(['model', 'view'], function(model, view) {

    JSON.load("/api/user", function(data) {
        document.getElementById("name").innerHTML = data.name;
    });

    model.load(function() {
        view.bins.setBins(model.user.bins);
        view.searchbox.addListener(function(form) {
            view.courses.setCourses(_.filter(model.courses.courses, function(c) {
                var terms = form.filter.toLowerCase().split(/\s/);
                var search = (c.id + ' ' + c.title).toLowerCase();
                return _(terms).every(function(term) { return search.indexOf(term) >= 0});
            }));
        });
        view.courses.setCourses(model.courses.courses);
        view.searchbox.enable();
    });

    view.setBinListener(function(data) {
        if (data.action.action == "remove") {
            JSON.send("/api/user/courses", "DELETE", {_id:data.course}, function(response) {
                if (response === undefined || typeof response === "number") {
                    alert("CONNECTION FAILURE; REFRESH PAGE!");
                }
                model.user.bins = _.map(model.user.bins, function(b) {
                    b.courses = _.filter(b.courses, function(c) {
                        return c.id !== data.course;
                    });
                    return b;
                });
                model.user.bins = _.filter(model.user.bins, function(b) { return b.courses.length > 0; });
                view.bins.setBins(model.user.bins);
            });
            return;
        }
        var message = { _id: data.course };
        if (data.action.type == "bin") {
            if (data.action.bin !== model.user.bins.length)
                message.before_bin = data.action.bin;
        }
        else
            message.to_bin = data.action.bin;
        JSON.send("/api/user/courses", "POST", message, function(response) {
            if (response === undefined || typeof response === "number") {
                if (response === 422 || response === 500) {
                }
                else
                    alert("CONNECTION FAILURE; REFRESH PAGE!");
                return;
            }
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
