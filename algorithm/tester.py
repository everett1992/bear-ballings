"""
Bear-Ballings:  Patrick D'Errico, Glen Oakley, Caleb Everett, Eric Palace

Holds the results and calls testing, input, and output functions
for the algorithmic porition of the system.
"""

#Note: call from command line proper syntax:
#python27 tester.py filepath

import protosort

import collections
import random
import json
import sys

# right now, one iteration
MAXCLASSES = 4
MAXCREDITS = 16
TRIALS = 1000

args = sys.argv
filename = args[min(1,len(args)-1)] #get filename as either first parameter, or return calling function

#definition of a user
User = collections.namedtuple("User", ["buckets", "classes", "credits", "id"])

#definition of a class
Class = collections.namedtuple("Class", ["id", "course_id", "seats", "day", "start_time", "end_time", "day2", "start_time2", "end_time2"])
Empty_Class = Class(-1, "EMPTY", 0, 0, 0, 0, 0, 0, 0) #used when a user does not need an additional class

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#list of all users
global_users = []
#list of all classes
global_classes = []

#collect data from file
json_data = []
if len(args) < 2:
    json_data=open("../lib/assets/sample.txt")
else:
    json_data=open(filename)

data = json.load(json_data)

#generate class sessions from database dump
c_g_id = 0
for c in data["courses"]: #for each course
    courseid = str(c["id"]) #get global course id, distinguishes sections of a course
    for classes in c["classes"]:
        m1 = classes["meeting1"] #get first meeting of class
        m2 = classes["meeting2"] #get second meeting
        global_classes.append(Class(c_g_id, courseid, int(classes["seats"]), int(m1["day"]), int(m1["starttime"]), int(m1["endtime"]), int(m2["day"]), int(m2["starttime"]), int(m2["endtime"])))
        c_g_id += 1 #each class must have a unique class id, will the the order they are fed in (starting at 0)

#generate users from database dump
for user in data["users"]:
    thisid = str(user["id"]) #get user id
    thisuserbin = [] #buckets fro the user
    thiscred = int(user["credits"]) #credits/priority level
    #make the initial list
    
    for bi in user["bins"]:

        thisbin = []
        #make a new list
        
        for c in bi["courses"]:
            thisbin.append(str(c))
            
        #append to initial list
        thisuserbin.insert(0,thisbin)

    #make the user here, need credits
    global_users.append(User(thisuserbin, [], thiscred, thisid))


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Sample data, left commented in case one wants to test it
'''
SAMPLE_USERS = [
                User([["CSC470", "CSC460"], ["CSC310", "CSC320"], ["CSC330", "CSC360"], ["WGS220", "WGS320"]], [], 13, "Bob"),
                User([["CSC470", "CSC320", "CSC360"], ["CSC460", "CSC330"], ["WGS220", "PHY120"], ["CSC320", "CSC310"]], [], 3, "Joe"),
                User([["CSC310", "CSC320"], ["CSC330", "CSC360"], ["CSC470", "PHY220"], ["WGS220", "WGS320", "PHY120"]], [], 5, "Mac"),
                ]
SAMPLE_CLASSES = [
                    Class(0, "CSC470", 3, 1, 1000, 1120, 1, 1000, 1120),
                    Class(1, "CSC460", 3, 1, 1000, 1130, 1, 1000, 1130),
                    Class(2, "CSC310", 3, 1, 900, 1500, 1, 900, 1500),
                    Class(3, "CSC320", 3, 2, 900, 1030, 2, 900, 1030),
                    Class(4, "CSC330", 3, 2, 1030, 1200, 2, 1030, 1200),
                    Class(5, "CSC360", 3, 3, 1100, 1230, 3, 1100, 1230),
                    Class(6, "WGS220", 3, 3, 2000, 2100, 3, 2000, 2100),
                    Class(7, "WGS320", 3, 3, 1400, 1530, 3, 1400, 1530),
                    Class(8, "PHY120", 3, 4, 1200, 1330, 4, 1200, 1330),
                    Class(9, "PHY220", 100, 5, 600, 800, 5, 600, 800),
                  ]
                #global id, name, max capacity, day, start time, end time
'''
'''
SAMPLE_USERS = [
                User([["CSC470", "CSC460"], ["CSC310", "CSC320"], ["CSC330", "CSC360"], ["WGS220", "WGS320"]], [], 13, "Bob"),
                User([["CSC470", "CSC320", "CSC360"], ["CSC460", "CSC330"], ["WGS220", "PHY120"], ["CSC320", "CSC310"]], [], 3, "Pa"),
                User([["CSC310", "CSC320"], ["CSC330", "CSC360"], ["CSC470", "PHY220"], ["WGS220", "WGS320", "PHY120"]], [], 5, "Alice"),
                User([["CSC310", "CSC320"], ["CSC330", "CSC360"], ["CSC470", "PHY220"], ["WGS220", "WGS320", "PHY120"]], [], 5, "Mac"),
                User([["CSC310", "CSC320"], ["CSC330", "CSC360"], ["CSC470", "PHY220"], ["WGS220", "WGS320", "PHY120"]], [], 5, "Kim"),
                User([["CSC310", "CSC320"], ["CSC330", "CSC360"], ["CSC470", "PHY220"], ["WGS220", "WGS320", "PHY120"]], [], 5, "Rob"),
                User([["CSC470"], ["CSC330", "CSC360"], ["CSC460", "CSC360"], ["WGS220", "WGS320", "PHY120"]], [], 5, "Ted"),
                User([["CSC470"], ["CSC330", "CSC360"], ["CSC460", "CSC360"], ["WGS220", "WGS320", "PHY120"]], [], 5, "Lou"),
                User([["CSC470"], ["CSC330", "CSC360"], ["CSC460", "CSC360"], ["WGS220", "WGS320", "PHY120"]], [], 5, "Ash"),
                ]
SAMPLE_CLASSES = [
                    Class(0, "CSC470", 3, 1, 1000, 1120, 1, 1000, 1120),
                    Class(1, "CSC460", 3, 1, 1000, 1130, 1, 1000, 1130),
                    Class(2, "CSC310", 3, 1, 900, 1500, 1, 900, 1500),
                    Class(3, "CSC320", 3, 2, 900, 1030, 2, 900, 1030),
                    Class(4, "CSC330", 3, 2, 1030, 1200, 2, 1030, 1200),
                    Class(5, "CSC360", 3, 3, 1100, 1230, 3, 1100, 1230),
                    Class(6, "WGS220", 3, 3, 2000, 2100, 3, 2000, 2100),
                    Class(7, "WGS320", 3, 3, 1400, 1530, 3, 1400, 1530),
                    Class(8, "PHY120", 3, 4, 1200, 1330, 4, 1200, 1330),
                    Class(9, "PHY220", 100, 5, 600, 800, 5, 600, 800),
                  ]
                #global id, name, max capacity, day, start time, end time
'''

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#functionality starts here

buckets = list() #save a seperate list of all buckets
prios = list() #save a list of all credits
#both are sent to eval function

buckets_taken = list() #create list of buckets taken to check against as to not pop buckets in class sort
for u in global_users:
    buckets.append(u.buckets) #get buckets for user
    prios.append(u.credits) #get credits for user
    bt = list()
    for b in u.buckets: #get each inner bucket in a user's preferences
        bt.append(False)
    buckets_taken.append(bt)

results = list()
for i in range(TRIALS):
    #run the algorithm a number of times to get different possibilities
    r = protosort.classsort(global_users, global_classes, protosort.gen_test_map(global_users))
    results.append(r)

#corresponds to the results
scores = list()
bestindex = 0 #index of highest scoring result
for q in range(TRIALS):
    #evaluate a result
    scores.append(protosort.eval_cs(results[q], buckets, prios))
    if scores[q] > scores[bestindex]: #if this result is better than the old best, make it the new best
        bestindex = q

#print scores[bestindex]
#print [r.classes for r in results[bestindex]]

#output to file, to this directory
outfile = open('outfile.txt', 'w')
classlist = [r.classes for r in results[bestindex]] #get the classes for each person in the optimal result
student_n = 0
for p in classlist:
    #start dumping
    outfile.write(str(global_users[student_n].id)) #write index of student, same as in input file, same order
    outfile.write('\n')
    for c in p:
        outfile.write(str(c)) #write each class the user takes
        outfile.write('\n')
    student_n += 1
