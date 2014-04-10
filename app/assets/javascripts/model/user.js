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
            updateUserBins(model.bins);
            if (callback)
                callback();
        });
    }

    model.load = load;

    return model;
});
