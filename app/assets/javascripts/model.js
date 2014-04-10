define(['model/courses', 'model/user'], function(courses, user) {

    var model = {};

    model.load = function(callback) {
        user.load(function() {
            courses.load(function() {
                model.courses = courses;
                model.user = user;
                if (callback)
                    callback();
            });
        });
    };

    return model;
});
