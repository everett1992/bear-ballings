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
            if (callback)
                callback();
        });
        //}, 1000);
    }

    model.load = load;

    return model;
});
