define(["model", "view"], function(model, view) {

    model.load(function () {
        view.searchbox.addListener(function(form) {
            view.updateCourses(_.filter(model.courses, function(c) {
                var term = form.filter;
                return (c.department.indexOf(term) >= 0 ||
                        c.number.toString().indexOf(term) >= 0 ||
                        (c.department+c.number.toString()).indexOf(term) >= 0 ||
                        c.title.indexOf(term) >= 0);
            }));
        });
        view.updateCourses(model.courses);
    });

    return {};
});
