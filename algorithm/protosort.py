# NOTES: needs testing
#        should run multiple times and then evaluate on how well it did

import random


def shuffled(iterable):
    return sorted(iterable, key=lambda x: random.getrandbits(1))


def zipindex(iterable):
    return zip([i for i in range(len(list(iterable)))], iterable)


# right now, one iteration
MAXCLASSES = 4
MAXCREDITS = 16


# bucketlist - all of the user's preferences, derived from the database
# userclasslist - what the user is currently enrolled in
#                 contains the same as classlist (below)
# usercreditlist - how many credits each user has
# **note that these three all should have the same size
# classlist - all of the classes (globally)
#             sublists contain the following:
#             [courseid (course number,
#              corresponds to course requests in bucketlist),
#              seatsleft,
#              globalid]
#             globalid distinguishes different classes with the same number
#             (like if different professors or something)
def classsort(bucketlist, userclasslist, usercreditlist, classlist):
    if complete(userclasslist, usercreditlist):
        return userclasslist

    if not len(userclasslist):
        raise ValueError("Empty list of user enrolled classes")
    if not len(usercreditlist):
        raise ValueError("Empty list of user credits")

    print("Working...")
    # print userclasslist
    # print bucketlist

    # ---------------------------------------
    # try to place a student
    # ---------------------------------------

    newbucketlist = bucketlist
    newuserclasslist = userclasslist
    # newusercreditlist = usercreditlist - credits are still the same
    newclasslist = classlist

    userclist = list(zip(userclasslist, usercreditlist))

    # get minimum length, pick among them
    minlen = min(map(len, userclasslist))

    # pick highest priority left
    maxprio = max(filter(lambda x: len(x[0]) == minlen, userclist),
                  key=lambda x: x[1])[1]

    # select a valid user
    # a valid user will have the highest priority of the ones with minlen
    user = next(filter(lambda x: len(x[1][0]) == minlen and x[1][1] == maxprio,
                       shuffled(zipindex(userclist))))[0]

    # account for classes the user need not take by adding blank entries
    # (if they have less than four classes this time around)
    if usercreditlist[user] > 12:
        if usercreditlist[user] + len(userclasslist[q]) >= MAXCREDITS:
            userclasslist[q].append([])
            return classsort(bucketlist,
                             userclasslist, usercreditlist,
                             classlist)

    # user still needs more classes
    added = False
    for bucket in bucketlist[user]:
        for cid in bucket:
            if not added:  # only add one class

                # make sure addition is still valid
                currentids = list()  # all ids the user is taking
                for c in userclasslist[user]:
                    if c != []:
                        currentids.append(getcourseid(c))

                # user isn't already signed up for a course with this id
                # (else invalid, try new course)
                if cid not in currentids:
                    globallist = list()  # all courses with this id
                    for gc in classlist:
                        if getcourseid(gc) == cid:
                            globallist.append(gc)
                    # if there is a course, add user if a spot is open
                    if len(globallist) > 0:
                        for gc in globallist:
                            if getseats(gc) > 0 and not added:
                                added = True
                                newclasslist[(getglobalid(gc))] = [gc[0], gc[1] - 1, gc[2]]
                                newuserclasslist[user].append(newclasslist[(getglobalid(gc))])

                                donecyc = False
                                for b in bucketlist[user]:  # remove list from new list, as it has been found
                                    if len(b) == len(bucket) and not donecyc:
                                        thesame = True
                                        for elenum in range(len(b)):
                                            if b[elenum] != bucket[elenum]:
                                                thesame = False
                                        if thesame:
                                            newbucketlist = list()
                                            for buckind in range(len(bucketlist)):
                                                if buckind != user:
                                                    newbucketlist.append(bucketlist[buckind])
                                                else:
                                                    internalbucket = list()
                                                    popped = False
                                                    for buckind2 in range(len(bucketlist[buckind])):
                                                        if cid in (bucketlist[buckind])[buckind2] and not popped:
                                                            internalbucket.append([])
                                                            popped = True
                                                        else:
                                                            internalbucket.append((bucketlist[buckind])[buckind2])
                                                    newbucketlist.append(internalbucket)

                                            print("Bucket Removed. New: ", newbucketlist)
                                            donecyc = True

    if not added:
        # pick random class if no buckets or valid choices
        while not added:
            gc = random.randint(0, (len(classlist) - 1))
            if getseats(gc) > 0:
                # make sure addition is still valid
                currentids = list()  # all ids the user is taking
                for c in userclasslist[user]:
                    if c != []:
                        currentids.append(getcourseid(c))

                # user isn't already signed up for a course with this id
                # (else invalid, try new course)
                if cid not in currentids:
                    added = True
                    newclasslist[(getglobalid(gc))] = [gc[0], gc[1] - 1, gc[2]]
                    newuserclasslist[user].append(newclasslist[(getglobalid(gc))])

                    donecyc = False
                    # remove list from new list, as it has been found
                    for b in bucketlist[user]:
                        if len(b) == len(bucket) and not donecyc:
                            thesame = True
                            for elenum in range(len(b)):
                                if b[elenum] != bucket[elenum]:
                                    thesame = False
                            if thesame:
                                newbucketlist = list()
                                for buckind in range(len(bucketlist)):
                                    if buckind != user:
                                        newbucketlist.append(bucketlist[buckind])
                                    else:
                                        internalbucket = list()
                                        popped = False
                                        for buckind2 in range(len(bucketlist[buckind])):
                                            if cid in (bucketlist[buckind])[buckind2] and not popped:
                                                internalbucket.append([])
                                                popped = True
                                            else:
                                                internalbucket.append((bucketlist[buckind])[buckind2])
                                        newbucketlist.append(internalbucket)

                                print("Bucket Removed. New: ", newbucketlist)
                                donecyc = True

    return classsort(newbucketlist, newuserclasslist, usercreditlist, newclasslist)


# input userclasslist, get back id
def getcourseid(entry):
    return entry[0]


# input classlist entry, get back seats
def getseats(entry):
    return entry[1]


# input classlist entry, get back seats
def getglobalid(entry):
    return entry[2]


# check for completion
def complete(userclasslist, usercreditlist):
    # see if any user is not fulfilled
    return not any(map(lambda x: len(x[0]) < MAXCLASSES and len(x[0]) + x[1] < MAXCREDITS,
                       zip(userclasslist, usercreditlist)))


buckets = [[[1, 2], [3, 4], [5, 6], [7, 8]],
           [[1, 4, 6], [2, 5], [7, 9], [4, 3]],
           [[3, 4], [5, 6], [1, 10], [7, 8, 9]]]
ubl = [[], [], []]
ucl = [12, 3, 5]
ci = [[1, 20, 0],
      [2, 10, 1],
      [3, 10, 2],
      [4, 15, 3],
      [5, 15, 4],
      [6, 20, 5],
      [7, 20, 6],
      [8, 10, 7],
      [9, 5, 8],
      [10, 100, 9]]
u = classsort(buckets, ubl, ucl, ci)
print(u)
