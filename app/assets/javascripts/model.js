define(['model/courses', 'model/user'], function(courses, user) {

    var model = {};

    function load() {
        courses.load(user.load(function() {
            model.courses = courses;
            model.user = user;
        }));
    }

    model.load = load;

    return model;
});
