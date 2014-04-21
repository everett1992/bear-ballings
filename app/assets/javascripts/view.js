define(['view/searchbox', 'view/course', 'view/bin'], function(searchbox, course, bin) {

    var active = undefined;
    var position = undefined;

    var elem_courses = document.getElementById("courses");

    var elem_bins = document.getElementById("bins");

    var courses = {};
    courses.setCourses = function(courses) {
        while (elem_courses.firstChild)
            elem_courses.removeChild(elem_courses.firstChild);
        _.each(courses, function(c) {
            var elem = course.create(c);
            elem.className += " unassigned";
            elem.onmousedown = onmousedown;
            elem_courses.appendChild(elem);
        });
    };

    var bins = {};
    bins.setBins = function(bins) {
        while (elem_bins.firstChild)
            elem_bins.removeChild(elem_bins.firstChild);
        _.each(bins, function(c) {
            var elem = bin.create(c);
            elem.className += " assigned";
            elem.onmousedown = onmousedown;
            elem_bins.appendChild(elem);
        });
    };

    function onmousedown(e) {
        if (e.button != 0)
            return;
        e.preventDefault();
        active = e.target;
        while (active.tagName.toUpperCase() != "LI")
            active = active.parentElement;
        document.onmousemove = onmousemove;
        document.onmouseup = onmouseup;
        if (active.setCapture) { active.setCapture(); }
        mousedown();
    }

    function onmousemove(e) {
        if (!active) {
            console.log("What did you do?  :C");
            return;
        }
        e.preventDefault();
        mousemove(e.pageX, e.pageY);
    }

    function onmouseup(e) {
        if (e.button != 0)
            return;
        e.preventDefault();
        mouseup();
        if (active.releaseCapture) { active.releaseCapture(); }
        document.onmouseup = undefined;
        document.onmousemove = undefined;
        active = undefined;
    }

    function mousedown() {
        active.style.backgroundColor = "yellow";
    }

    function nobodywillreadthis(es, x,y) {
        var bounds = _.map(es, function(b) { return { e:b, s:b.getBoundingClientRect() }; });
        if (_.first(bounds).s.top >= y)
            return "ABOVE";
        if (_.last(bounds).s.bottom <= y)
            return "BELOW";
        var hoverbin = _.findWhere(bounds, function(b) { return (y >= b.s.top && y <= b.s.bottom); });
        if (hoverbin)
            return hoverbin;
        var middle = _.findWhere(_.zip(_.initial(bounds), _.rest(bounds)), function(tb) {
            return (y - tb[0].s.bottom || tb[1].s.top - y < 0);
        });
        if (middle)
            return middle;
        return undefined;
    }

    function mousemove(x,y) {
        var type = (active.className.indexOf("unassigned") < 0 ? "assigned" : "unassigned");
        if (type !== "unassigned")
            return;
        var bins_b = elem_bins.getBoundingClientRect();
        if (x < bins_b.left || bins_b.right < x || y < bins_b.top || bins_b.bottom < y)
            return;
        position = nobodywillreadthis(elem_bins.children, x,y);
        if (position.length == 2) {
            position = "MIDDLE";
        }
        if (position.length)
            return;
        position = nobodywillreadthis(position.e.children, x,y);
        if (position.length == 2) {
            position = "MIDDLE";
        }
        position = "INNER " + position;
    }

    function mouseup() {
        active.style.backgroundColor = "";
        console.log(position);
    }

    return {
        searchbox: searchbox,
        courses: courses,
        bins: bins
    };
});
