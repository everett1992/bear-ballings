define(['view/searchbox', 'view/course', 'view/bin'], function(searchbox, course, bin) {

    const HR = document.createElement("hr");

    var active = undefined;
    var undo = undefined;
    var action = undefined;

    var elem_courses = document.getElementById("courses");

    var elem_bins = document.getElementById("bins");

    var binlistener = undefined;
    function setBinListener(callback) {
        binlistener = callback;
    }

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
            elem.onmousedown = onmousedown;
            //var li = document.createElement("li");
            //li.appendChild(elem);
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

    function narrowdown(es, x,y) {
        if (!es.length)
            return {type: "BELOW"};
        var bounds = _.map(es, function(b) { return { e:b, s:b.getBoundingClientRect() }; });
        if (_.first(bounds).s.top >= y)
            return {type: "ABOVE"};
        if (_.last(bounds).s.bottom <= y)
            return {type: "BELOW"};
        var hoverbin = _.find(bounds, function(b) { return (b.s.top <= y && b.s.bottom >= y); });
        if (hoverbin)
            return {type: "ON", value: hoverbin};
        var middle = _.find(_.zip(_.initial(bounds), _.rest(bounds)), function(tb) {
            return (tb[0].s.bottom < y && tb[1].s.top > y);
        });
        if (middle)
            return {type: "MIDDLE",
                    top: middle[0],
                    bot: middle[1]};
        return undefined;
    }

    function mousemove(x,y) {
        var type,
            bins_bound,
            position_bin,
            position_c,
            cbin;
        if (undo)
            undo();
        undo = undefined;
        action = undefined;
        type = (active.className.indexOf("unassigned") < 0 ? "assigned" : "unassigned");
        if (type !== "unassigned")
            return;
        bins_bound = elem_bins.getBoundingClientRect();
        if (x < bins_bound.left || bins_bound.right < x || y < bins_bound.top || bins_bound.bottom < y)
            return;
        position_bin = narrowdown(elem_bins.getElementsByClassName("bin"), x,y);
        if (position_bin.type == "ON") {
            action = {bin:_.indexOf(elem_bins.children, position_bin.value.e), type:"course", action:"insert"};
            cbin = position_bin.value.e.children[0];
            position_c = narrowdown(cbin.getElementsByClassName("course"), x,y);
            if (position_c.type == "ON") {
                action = undefined;
            }
            else if (position_c.type == "MIDDLE") {
                action.course = _.indexOf(cbin.children, position_c.bot.e);
                undo = function() { cbin.removeChild(HR); };
                cbin.insertBefore(HR, position_c.bot.e);
            }
            else if (position_c.type == "ABOVE") {
                action.course = 0;
                undo = function() { cbin.removeChild(HR); };
                cbin.insertBefore(HR, cbin.children[0]);
            }
            else if (position_c.type == "BELOW") {
                action.course = cbin.children.length;
                undo = function() { cbin.removeChild(HR); };
                cbin.appendChild(HR);
            }
        }
        else if (position_bin.type == "MIDDLE") {
            action = {bin:_.indexOf(elem_bins, position_bin.bot.e.children), type:"bin", action:"insert"};
            undo = function() { elem_bins.removeChild(HR); };
            elem_bins.insertBefore(HR, position_bin.bot.e);
        }
        else if (position_bin.type == "ABOVE") {
            action = {bin:0, type:"bin", action:"insert"};
            undo = function() { elem_bins.removeChild(HR); };
            elem_bins.insertBefore(HR, elem_bins.children[0]);
        }
        else if (position_bin.type == "BELOW") {
            action = {bin:elem_bins.children.length, type:"bin", action:"insert"};
            undo = function() { elem_bins.removeChild(HR); };
            elem_bins.appendChild(HR);
        }
        else {
            alert(undefined);
        }
    }

    function mouseup() {
        if (undo)
            undo();
        undo = undefined;
        active.style.backgroundColor = "";
        if (action && binlistener)
            binlistener({course:active.id.substr(7), action:action});
    }

    return {
        searchbox: searchbox,
        courses: courses,
        bins: bins,
        setBinListener: setBinListener
    };
});
