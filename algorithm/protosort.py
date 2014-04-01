#NOTES: needs testing, should run multiple times and then evaluate on how well it did
import random

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

    print "Working..."
    #print userclasslist
    #print bucketlist

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
        #print ru, minilen, maxprio
        #print (len(userclasslist[ru])), usercreditlist[ru]
        if ((len(userclasslist[ru]) == minilen) and usercreditlist[ru] == maxprio):
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
                    if len(globallist) > 0: #if there is a course, add user if the course has spots open
                        for gc in globallist:
                            if getseats(gc) > 0 and added == False:
                                added = True
                                newclasslist[(getglobalid(gc))] = [gc[0], gc[1]-1, gc[2]]
                                newuserclasslist[user].append(newclasslist[(getglobalid(gc))])

                                donecyc = False
                                for b in bucketlist[user]: #remove list from new list, as it has been found
                                    if len(b) == len(bucket) and donecyc == False:
                                        thesame = True
                                        for elenum in range(len(b)):
                                            if b[elenum] != bucket[elenum]:
                                                thesame = False
                                        if thesame == True:
                                            newbucketlist = list()
                                            for buckind in range(len(bucketlist)):
                                                if buckind != user:
                                                    newbucketlist.append(bucketlist[buckind])
                                                else:
                                                    internalbucket = list()
                                                    popped = False
                                                    for buckind2 in range(len(bucketlist[buckind])):
                                                        if cid in (bucketlist[buckind])[buckind2] and popped == False:
                                                            internalbucket.append([])
                                                            popped = True
                                                        else:
                                                            internalbucket.append((bucketlist[buckind])[buckind2])
                                                    newbucketlist.append(internalbucket)
               
                                            print "Bucket Removed. New: ", newbucketlist
                                            donecyc = True    
                                

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
                    newclasslist[(getglobalid(gc))] = [gc[0], gc[1]-1, gc[2]]
                    newuserclasslist[user].append(newclasslist[(getglobalid(gc))])

                    donecyc = False
                    for b in bucketlist[user]: #remove list from new list, as it has been found
                        if len(b) == len(bucket) and donecyc == False:
                            thesame = True
                            for elenum in range(len(b)):
                                if b[elenum] != bucket[elenum]:
                                    thesame = False
                            if thesame == True:
                                newbucketlist = list()
                                for buckind in range(len(bucketlist)):
                                    if buckind != user:
                                        newbucketlist.append(bucketlist[buckind])
                                    else:
                                        internalbucket = list()
                                        popped = False
                                        for buckind2 in range(len(bucketlist[buckind])):
                                            if cid in (bucketlist[buckind])[buckind2] and popped == False:
                                                internalbucket.append([])
                                                popped = True
                                            else:
                                                internalbucket.append((bucketlist[buckind])[buckind2])
                                        newbucketlist.append(internalbucket)
   
                                print "Bucket Removed. New: ", newbucketlist
                                donecyc = True              

    return classsort(newbucketlist, newuserclasslist, usercreditlist, newclasslist)
    
def getcourseid(entry): #input userclasslist, get back id
    return entry[0]

def getseats(entry): #input classlist entry, get back seats
    return entry[1]

def getglobalid(entry): #input classlist entry, get back seats
    return entry[2]
    
def complete(userclasslist, usercreditlist): #check for completion
    for q in range(len(userclasslist)):
        if ((len(userclasslist[q]) < MAXCLASSES) and (len(userclasslist[q]) + usercreditlist[q] < MAXCREDITS)): #see if user is not fulfilled
            return False
    return True

buckets = [ [[1,2],[3,4],[5,6],[7,8]] , [[1,4,6],[2,5],[7,9],[4,3]] , [[3,4],[5,6],[1,10],[7,8,9]] ]
ubl = [[],[],[]]
ucl = [12,3,5]
ci = [[1,20,0],[2,10,1],[3,10,2],[4,15,3],[5,15,4],[6,20,5],[7,20,6],[8,10,7],[9,5,8],[10,100,9]]
u = classsort(buckets, ubl, ucl, ci)
print(u)
