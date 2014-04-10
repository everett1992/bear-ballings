define(['view/bin'], function(bin) {

    var view = {};

    var elem_bins = document.getElementById("bins");

    view.setBins = function(bins) {
        while (elem_bins.firstChild)
            elem_bins.removeChild(elem_bins.firstChild);
        _.each(bins, function(c) {
            var elem = bin.create(c);
            elem.className += " assigned";
            elem_bins.appendChild(elem);
        });
    };

    return view;
});
