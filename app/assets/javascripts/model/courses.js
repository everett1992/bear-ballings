define(function() {

    var model = {};

    function load(callback) {
        //setTimeout(function() {
        //var data = { courses : [ { department : "AES", number : 100, title: "HELLO WORLD" }]};
        JSON.load("/api/courses", function(data) {
            if (!data) {
                alert("ERROR LOADING DATA");
                return;
            }
            model.courses = data.courses;
            _.each(model.courses, function(c) {
                c.id = c.department + (c.number < 100 ? '0' : '') + c.number;
            });
            if (callback)
                callback();
        });
        //}, 1000);
    }

    model.load = load;

    return model;
});
