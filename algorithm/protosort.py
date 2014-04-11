"""Algorithm(s) for the CSC470 project."""

# NOTES: needs testing
#        should run multiple times and then evaluate on how well it did

import collections
import random


# right now, one iteration
MAXCLASSES = 4
MAXCREDITS = 16


User = collections.namedtuple("User", ["buckets", "classes", "credits"])

Class = collections.namedtuple("Class", ["id", "course_id", "seats", "day", "start_time", "end_time"])


def classsort(users, classes):
    """Place users into classes in-place.

    Returns the users list, which will be modified for enrollment.
    """
    if is_complete(users):
        return users

    # ---------------------------------------
    # try to place a student
    # ---------------------------------------

    # get minimum length, pick among them
    min_classes_len = min([len(u.classes) for u in users])

    # pick the highest-priority users with the minimum number of classes
    max_credits = max([u.credits for u in users
                       if len(u.classes) == min_classes_len])

    # schedule a user that meets the previous criteria
    # and has not reached the credit limit
    user = random.choice([u for u in users
                          if u.credits == max_credits
                          and len(u.classes) == min_classes_len
                          and len(u.classes) + u.credits < MAXCREDITS])

    open_class = None
    while user.buckets:
        bucket = user.buckets.pop()
        for course_id in bucket:
            # check if this class has been enrolled already for this user
            if course_id in [x[0] for x in user.classes]:
                continue
            # find an open class for this course
            open_classes = [c for c in classes
                            if c.course_id == course_id and c.seats > 0 and (t_conflict(user.classes, c) == False)]
            if not open_classes:
                continue
            open_class = open_classes[0]
            
            # enroll the user in the class (store course_id and class_id)
            user.classes.append((course_id, open_class.id, open_class.day, open_class.start_time, open_class.end_time))
            break
        else:
            # this bucket had no open course classes; move to the next bucket
            continue
        break
    else:
        # all requested course classes were full
        # pick a random class and enroll
        open_classes = [c for c in classes if c.seats > 0 and (t_conflict(user.classes, c) == False)]
        if not open_classes:
            print("BAD NEWS: OUT OF CLASSES!")
            assert False
        open_class = random.choice(open_classes)
        user.classes.append((open_class.course_id, open_class.id, open_class.day, open_class.start_time, open_class.end_time))
    # ensure SOME class was picked
    assert open_class is not None
    # recurse with the new state of the user being enrolled in a new class
    return classsort(users, [c if c != open_class else
                             Class(open_class.id,
                                   open_class.course_id,
                                   open_class.seats - 1,
                                   open_class.day,
                                   open_class.start_time,
                                   open_class.end_time)
                             for c in classes])


def is_complete(users):
    """Check if some users have all been fully scheduled"""
    return all([len(u.classes) >= MAXCLASSES or
                len(u.classes) + u.credits >= MAXCREDITS
                for u in users])

def t_conflict(user_classes, course):
    days = [c[2] for c in user_classes] #list of days
    if (course.day in days) == False:
        return False
    else:
        c_starts = [c[3] for c in user_classes if c[2] == course.day]    
        c_ends = [c[4] for c in user_classes if c[2] == course.day]
        #will match
        
        for con in range(len(c_starts)):
            if ((course.start_time >= c_starts[con] and course.start_time <= c_ends[con]) or (course.end_time >= c_starts[con] and course.end_time <= c_ends[con]) or (course.start_time <= c_starts[con] and course.end_time >= c_ends[con])):
                return True
            
        return False


SAMPLE_USERS = [User([["CSC470", "CSC460"], ["CSC310", "CSC320"], ["CSC330", "CSC360"], ["WGS220", "WGS320"]], [], 12),
                User([["CSC470", "CSC320", "CSC360"], ["CSC460", "CSC330"], ["WGS220", "PHY120"], ["CSC320", "CSC310"]], [], 3),
                User([["CSC310", "CSC320"], ["CSC330", "CSC360"], ["CSC470", "PHY220"], ["WGS220", "WGS320", "PHY120"]], [], 5)]
SAMPLE_CLASSES = [Class(0, "CSC470", 20, 1, 1000, 1120),
                  Class(1, "CSC460", 10, 1, 1000, 1130),
                  Class(2, "CSC310", 10, 1, 900, 1500),
                  Class(3, "CSC320", 15, 2, 900, 1030),
                  Class(4, "CSC330", 15, 2, 1030, 1200),
                  Class(5, "CSC360", 20, 3, 1100, 1230),
                  Class(6, "WGS220", 20, 3, 2000, 2100),
                  Class(7, "WGS320", 10, 3, 1400, 1530),
                  Class(8, "PHY120", 5, 4, 1200, 1330),
                  Class(9, "PHY220", 100, 5, 830, 1000)]
RESULT = classsort(SAMPLE_USERS, SAMPLE_CLASSES)
print([r.classes for r in RESULT])
