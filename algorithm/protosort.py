"""Algorithm(s) for the CSC470 project."""

import collections
import random


# right now, one iteration
MAXCLASSES = 4
MAXCREDITS = 16

User = collections.namedtuple("User", ["buckets", "classes", "credits", "id"])

Class = collections.namedtuple("Class", ["id", "course_id", "seats", "day", "start_time", "end_time", "day2", "start_time2", "end_time2"])
Empty_Class = Class(-1, "EMPTY", 0, 0, 0, 0, 0, 0, 0)

def classsort(users, classes, buckets_taken):
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
    randomuserlist = [u for u in range(len(users))
                        if users[u].credits == max_credits
                        and len(users[u].classes) == min_classes_len
                        and len(users[u].classes) + users[u].credits < MAXCREDITS]

    empty_class = False
    user_num = -1
    if len(randomuserlist) > 0:
        user_num = random.choice(randomuserlist)

    if user_num == -1: #find a user with the most credits only
        randomuserlist = [u for u in range(len(users))
                            if users[u].credits == max_credits
                            and len(users[u].classes) == min_classes_len]
        user_num = random.choice(randomuserlist)
        empty_class = True
    
    user = users[user_num]

    open_class = None
    ind = 0     

    if empty_class == False: #if we need to add a class, try to do so
        while ind < len(user.buckets):
            bucket = user.buckets[ind]
            if buckets_taken[user_num][ind] == True: #user has a class in this bucket
                ind += 1
                continue
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
                buckets_taken[user_num][ind] = True
                user.classes.append((course_id, open_class.id, open_class.day, open_class.start_time, open_class.end_time, open_class.day2, open_class.start_time2, open_class.end_time2))
                break
            else:
                # this bucket had no open course classes; move to the next bucket
                ind += 1
                continue
            break
        else:
            # all requested course classes were full
            # pick a random class and enroll
            open_classes = [c for c in classes if c.seats > 0 and (t_conflict(user.classes, c) == False)]
            if not open_classes: #recurses back so you can try again, 0 is a signa for repeating an iteration of the loop, assuming classes will not be left if a pick is made
                #print("BAD NEWS: OUT OF CLASSES!")
                #assert False
                return 0
            
            open_class = random.choice(open_classes)
            user.classes.append((course_id, open_class.id, open_class.day, open_class.start_time, open_class.end_time, open_class.day2, open_class.start_time2, open_class.end_time2))

    #-------------------------------------------
    #endgame
    #-------------------------------------------

    if empty_class == True:
        user.classes.append((-1, "EMPTY", 0, 0, 0, 0, 0, 0, 0))
        open_class = Empty_Class

    # ensure SOME class was picked
    assert open_class is not None
    # recurse with the new state of the user being enrolled in a new class
    final_result = classsort(users, [c if c != open_class else
                             Class(open_class.id,
                                   open_class.course_id,
                                   open_class.seats - 1,
                                   open_class.day,
                                   open_class.start_time,
                                   open_class.end_time,
                                   open_class.day2,
                                   open_class.start_time2,
                                   open_class.end_time2)
                             for c in classes], buckets_taken)

    if final_result != 0:
        return final_result
    else:
        return classsort(users, classes, buckets_taken) #try again if a move would lead to no other options.
        


def is_complete(users):
    """Check if some users have all been fully scheduled"""
    return all([len(u.classes) >= MAXCLASSES or
                len(u.classes) + u.credits >= MAXCREDITS
                for u in users])

def t_conflict(user_classes, course):
    days = [c[2] for c in user_classes if c[2] > 0] #list of days
    days2 = [c[5] for c in user_classes if c[5] > 0] #list of days
    if (course.day in days) == False and (course.day in days2) == False:
        return False
    else:
        c_starts = [c[3] for c in user_classes if c[2] == course.day]    
        c_ends = [c[4] for c in user_classes if c[2] == course.day]
        c_starts2 = [c[6] for c in user_classes if c[5] == course.day2]    
        c_ends2 = [c[7] for c in user_classes if c[5] == course.day2]
        #will match lengths
        
        for con in range(len(c_starts)):
            if ((course.start_time >= c_starts[con] and course.start_time <= c_ends[con]) or (course.end_time >= c_starts[con] and course.end_time <= c_ends[con]) or (course.start_time <= c_starts[con] and course.end_time >= c_ends[con])):
                return True
            if ((course.start_time2 >= c_starts2[con] and course.start_time2 <= c_ends2[con]) or (course.end_time2 >= c_starts2[con] and course.end_time2 <= c_ends2[con]) or (course.start_time2 <= c_starts2[con] and course.end_time2 >= c_ends2[con])):
                return True
            
        return False

def eval_cs(result, buckets, prios):

    r_classes = [r.classes for r in result] #get class list

    #generate map of whether a bucket was used
    buckets_used = gen_test_map(r_classes)
    
    score = 0
    for u in range(len(r_classes)): #test per user
        bucketsleft = buckets[u]
        prio = prios[u]
        
        for c in r_classes[u]: #check to see if each result is in a bucket, try to remove matches first
            inserted = False
            for b in range(len(bucketsleft)): #go through buckets to check things out
                if (c[0] in bucketsleft[b]) and inserted == False and buckets_used[u][b] == False:
                    score += prio
                    inserted = True
                    buckets_used[u][b] = True

    return score

def gen_test_map(users): #makes a list of all buckets for each user, starts at false - means: "nothing taken from here yet"
    result = list()
    for u in users:
        bt = list()
        for b in u:
            bt.append(False)
        result.append(bt)
    return result
