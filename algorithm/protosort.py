"""Algorithm(s) for the CSC470 project."""

# NOTES: needs testing
#        should run multiple times and then evaluate on how well it did

import collections
import random


# right now, one iteration
MAXCLASSES = 4
MAXCREDITS = 16


User = collections.namedtuple("User", ["buckets", "classes", "credits"])

Class = collections.namedtuple("Class", ["id", "course_id", "seats"])


def classsort(users, classes):
    """Place users into classes in-place.

    Returns the users argument, which will be modified for enrollment.
    """
    if is_complete(users):
        return users

    print("Working...")
    # print userclasslist
    # print bucketlist

    # ---------------------------------------
    # try to place a student
    # ---------------------------------------

    # get minimum length, pick among them
    min_classes_len = min([len(u.classes) for u in users])

    # pick the highest-priority users with the minimum number of classes
    max_credits = max([u.credits for u in users
                       if len(u.classes) == min_classes_len])

    # pick one of the candidates to schedule
    user = random.choice([u for u in users
                          if u.credits == max_credits
                          and len(u.classes) == min_classes_len])

    # account for classes the user need not take by adding blank entries
    # (if they have less than four classes this time around)
    if user.credits > 12:
        if user.credits + len(user.classes) >= MAXCREDITS:
            user.classes.append([])
            return classsort(users, classes)

    # user still needs more classes
    open_class = None
    while user.buckets:
        bucket = user.buckets.pop()
        for course_id in bucket:
            # check if this class has been enrolled already for this user
            if course_id in [x[0] for x in user.classes]:
                continue
            open_classes = [c for c in classes
                            if c.course_id == course_id and c.seats > 0]
            if not open_classes:
                continue
            open_class = open_classes[0]
            user.classes.append((course_id, open_class.id))
            break
        else:
            continue
        break
    else:
        # could not add a user to their requested classes
        # pick a random class and enroll
        open_classes = [c for c in classes if c.seats > 0]
        if not open_classes:
            print("BAD NEWS: OUT OF CLASSES!")
            assert False
        open_class = random.choice(open_classes)
        open_class.seats -= 1
        user.classes.append((open_class.course_id, open_class.id))
    assert open_class is not None
    return classsort(users, [c if c != open_class else
                             Class(open_class.id,
                                   open_class.course_id,
                                   open_class.seats - 1)
                             for c in classes])


def is_complete(users):
    """Check if some users have all been fully scheduled"""
    return all([len(u.classes) >= MAXCLASSES or
                len(u.classes) + u.credits >= MAXCREDITS
                for u in users])


SAMPLE_USERS = [User([[1, 2], [3, 4], [5, 6], [7, 8]], [], 12),
                User([[1, 4, 6], [2, 5], [7, 9], [4, 3]], [], 3),
                User([[3, 4], [5, 6], [1, 10], [7, 8, 9]], [], 5)]
SAMPLE_CLASSES = [Class(0, 1, 20),
                  Class(1, 2, 10),
                  Class(2, 3, 10),
                  Class(3, 4, 15),
                  Class(4, 5, 15),
                  Class(5, 6, 20),
                  Class(6, 7, 20),
                  Class(7, 8, 10),
                  Class(8, 9, 5),
                  Class(9, 10, 100)]
RESULT = classsort(SAMPLE_USERS, SAMPLE_CLASSES)
print([r.classes for r in RESULT])
