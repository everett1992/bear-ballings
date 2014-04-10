define(function() {

    var view = {};

    var elem_filter = document.getElementById("searchtext");

    var listeners = [];

    elem_filter.addEventListener("input", _.debounce(function(e) {
        view.filter.value = elem_filter.value;
        _.each(listeners, function(f) { f({filter: view.filter.value}); });
    }, 200));


    view.filter = {};
    view.filter.value = elem_filter.value;
    view.addListener = function(listener) {
        listeners.push(listener);
    };

    return view;
});
