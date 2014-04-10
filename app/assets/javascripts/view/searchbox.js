define(function() {

    var view = {};

    var elem_filter = document.getElementById("searchtext");

    var listeners = [];

    elem_filter.addEventListener("input", _.debounce(function(e) {
        _.each(listeners, function(f) { f({filter: elem_filter.value}); });
    }, 200));


    view.filter = {};
    view.filter.value = elem_filter.value;
    view.addListener = function(listener) {
        listeners.push(listener);
    };

    return view;
});
