#NOTES: needs testing, should run multiple times and then evaluate on how well it did

#right now, one iteration
MAXCLASSES = 4
MAXCREDITS = 16

#bucketlist - all of the user's preferences, derived from the database
#userclasslist - what the user is currently enrolled in -> contains the same as classlist (below)
#usercreditlist - how many credits each user has
#**note that these three all should have the same size
#classlist - all of the classes (globally) -- sublists contain the following [courseid (course number, corresponds to course requests in bucketlist), seatsleft, globalid (distinguishes different classes with the same number...like if different professors or something)]
def classsort(bucketlist, userclasslist, usercreditlist, classlist):
    if complete(userclasslist, usercreditlist) == True:
        return userclasslist

    #---------------------------------------
    #try to place a student
    #---------------------------------------

    newbucketlist = bucketlist
    newuserclasslist = userclasslist
    #newusercreditlist = usercreditlist - credits are still the same
    newclasslist = classlist
    
    #get minimum length, pick among them
    minilen = MAXCLASSES
    for q in range(len(userclasslist)):
       if ((len(userclasslist[q]) < minilen)):
           minilen = len(userclasslist[q])

    #pick highest priority left
    maxprio = -1
    for q in range(len(userclasslist)):
        if ((len(userclasslist[q]) == minilen) and usercreditlist[q] > maxprio):
            maxprio = usercreditlist[q]

    #select a valid user - a valid user will have the highest priority of the ones with minilen
    user = -1
    while user == -1:
        ru = random.randint(0,(len(userclasslist)-1))
        if ((len(userclasslist[q]) == minilen) and usercreditlist[q] == maxprio):
            user = ru

    #account for classes the user need not take, if they have less than four classes this time around, by adding blank entries    
    if usercreditlist[user] > 12:
        if usercreditlist[user] + len(userclasslist[q]) >= MAXCREDITS:
            userclasslist[q].append([])
            return classsort(bucketlist, userclasslist, usercreditlist, classlist)

    #user still needs more classes
    added = False
    for bucket in bucketlist[user]:
        for cid in bucket:
            if added == False: #only add one class
                
                #make sure addition is still valid
                currentids = list() #all ids the user is taking
                for c in userclasslist[user]:
                    if c != []:
                        currentids.append(getcourseid(c))
                    
                if cid not in currentids: #user isn't already signed up for a course with this id, else invalid, try new course
                    globallist = list() #all courses with this id
                    for gc in classlist:
                        if (getcourseid(gc) == cid):
                            globallist.append(gc)
                    if length(globallist) > 0: #if there is a course, add user if the course has spots open
                        for gc in globalist:
                            if getseats(gc) > 0 and added == False:
                                added = True
                                newclasslist[(getcourseid(gc))] = [gc[0], gc[1]-1, gc[2]]
                                newuserclasslist[user].append(newclasslist[(getcourseid(gc))])
                                for b in newbucketlist[user]: #remove list from new list, as it has been found
                                    if b == bucket:
                                        b = []
                                

    if added == False:
        #pick random class if no buckets or valid choices
        while added == False:
            gc = random.randint(0,(len(classlist)-1))
            if getseats(gc) > 0:
                #make sure addition is still valid
                currentids = list() #all ids the user is taking
                for c in userclasslist[user]:
                    if c != []:
                        currentids.append(getcourseid(c))
                    
                if cid not in currentids: #user isn't already signed up for a course with this id, else invalid, try new course
                    added = True
                    newclasslist[(getcourseid(gc))] = [gc[0], gc[1]-1, gc[2]]
                    newuserclasslist[user].append(newclasslist[(getcourseid(gc))])
                    for b in newbucketlist[user]: #remove list from new list, as it has been found
                        if b == bucket:
                            b = []                    

    return classsort(newbucketlist, newuserclasslist, usercreditlist, newclasslist)
    
def getcourseid(entry): #input userclasslist, get back id
    return entry[0]

def getseats(entry): #input classlist entry, get back seats
    return entry[1]
    
def complete(userclasslist, usercreditlist): #check for completion
    for q in range(len(userclasslist)):
        if ((len(userclasslist[q]) < MAXCLASSES) and (len(userclasslist[q]) + usercreditlist[q] < MAXCREDITS)): #see if user is not fulfilled
            return False
    return True
