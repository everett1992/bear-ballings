define(function() {

    var model = {};

    function load(callback) {
        JSON.load("/api/user/courses", function(data) {
            if (!data) {
                alert("ERROR LOADING DATA");
                return;
            }
            model.bins = _.map(data.bins, function(b) {
                return { courses: b.bin.courses };
            });
            model.bins = _.each(model.bins, function(b) {
                _.each(b.courses, function(c) {
                    c.id = c.department + (c.number < 100 ? '0' : '') + c.number;
                });
            });
            if (callback)
                callback();
        });
    }

    model.load = load;

    return model;
});
