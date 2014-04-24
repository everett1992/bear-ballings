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
    });

    return {};
});
