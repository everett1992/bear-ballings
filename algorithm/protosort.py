#right now, one iteration
MAXCLASSES = 4
MAXCREDITS = 16

#bucketlist - all of the user's preferences, derived from the database
#userclasslist - what the user is currently enrolled in
#usercreditlist - how many credits each user has
#**note that these three all should have the same size
#classlist - all of the classes (globally)
def classsort(bucketlist, userclasslist, usercreditlist, classlist):
    if complete(userclasslist, usercreditlist) == True:
        return userclasslist

    #---------------------------------------
    #try to place a student
    #---------------------------------------
    
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
        if added == False:
            for id in bucket:
                #do this
        

def complete(userclasslist, usercreditlist):
    for q in range(len(userclasslist)):
        if ((len(userclasslist[q]) < MAXCLASSES) and (len(userclasslist[q]) + usercreditlist[q] < MAXCREDITS)): #see if user is not fulfilled
            return False
    return True
