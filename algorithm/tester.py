import protosort

import collections
import random

# right now, one iteration
MAXCLASSES = 4
MAXCREDITS = 16
TRIALS = 1000

User = collections.namedtuple("User", ["buckets", "classes", "credits"])

Class = collections.namedtuple("Class", ["id", "course_id", "seats", "day", "start_time", "end_time"])


SAMPLE_USERS = [
                User([["CSC470", "CSC460"], ["CSC310", "CSC320"], ["CSC330", "CSC360"], ["WGS220", "WGS320"]], [], 12),
                User([["CSC470", "CSC320", "CSC360"], ["CSC460", "CSC330"], ["WGS220", "PHY120"], ["CSC320", "CSC310"]], [], 3),
                User([["CSC310", "CSC320"], ["CSC330", "CSC360"], ["CSC470", "PHY220"], ["WGS220", "WGS320", "PHY120"]], [], 5),
                User([["CSC310", "CSC320"], ["CSC330", "CSC360"], ["CSC470", "PHY220"], ["WGS220", "WGS320", "PHY120"]], [], 5),
                User([["CSC310", "CSC320"], ["CSC330", "CSC360"], ["CSC470", "PHY220"], ["WGS220", "WGS320", "PHY120"]], [], 5),
                User([["CSC310", "CSC320"], ["CSC330", "CSC360"], ["CSC470", "PHY220"], ["WGS220", "WGS320", "PHY120"]], [], 5),
                User([["CSC470"], ["CSC330", "CSC360"], ["CSC460", "CSC360"], ["WGS220", "WGS320", "PHY120"]], [], 5),
                User([["CSC470"], ["CSC330", "CSC360"], ["CSC460", "CSC360"], ["WGS220", "WGS320", "PHY120"]], [], 5),
                User([["CSC470"], ["CSC330", "CSC360"], ["CSC460", "CSC360"], ["WGS220", "WGS320", "PHY120"]], [], 5),
                ]
SAMPLE_CLASSES = [
                    Class(0, "CSC470", 3, 1, 1000, 1120),
                    Class(1, "CSC460", 3, 1, 1000, 1130),
                    Class(2, "CSC310", 3, 1, 900, 1500),
                    Class(3, "CSC320", 3, 2, 900, 1030),
                    Class(4, "CSC330", 3, 2, 1030, 1200),
                    Class(5, "CSC360", 3, 3, 1100, 1230),
                    Class(6, "WGS220", 3, 3, 2000, 2100),
                    Class(7, "WGS320", 3, 3, 1400, 1530),
                    Class(8, "PHY120", 3, 4, 1200, 1330),
                    Class(9, "PHY220", 100, 5, 600, 800),
                  ]
                #global id, name, max capacity, day, start time, end time
'''

SAMPLE_USERS = [
                User([["CSC310", "CSC320"], ["CSC330", "CSC360"], ["CSC470", "PHY220"], ["WGS220", "WGS320", "PHY120"]], [], 5),
                User([["CSC310", "CSC320"], ["CSC330", "CSC360"], ["CSC470", "PHY220"], ["WGS220", "WGS320", "PHY120"]], [], 5),
                User([["CSC310", "CSC320"], ["CSC330", "CSC360"], ["CSC470", "PHY220"], ["WGS220", "WGS320", "PHY120"]], [], 5),
                User([["CSC310", "CSC320"], ["CSC330", "CSC360"], ["CSC470", "PHY220"], ["WGS220", "WGS320", "PHY120"]], [], 5),
                ]
SAMPLE_CLASSES = [
                    Class(0, "CSC470", 1, 1, 1000, 1120),
                    Class(1, "CSC460", 1, 1, 1000, 1130),
                    Class(2, "CSC310", 1, 1, 900, 1500),
                    Class(3, "CSC320", 1, 2, 900, 1030),
                    Class(4, "CSC330", 1, 2, 1030, 1200),
                    Class(5, "CSC360", 1, 3, 1100, 1230),
                    Class(6, "WGS220", 10, 3, 2000, 2100),
                    Class(7, "WGS320", 10, 3, 1400, 1530),
                    Class(8, "PHY120", 10, 4, 1200, 1330),
                    Class(9, "PHY220", 100, 5, 600, 800),
                  ]
                #global id, name, max capacity, day, start time, end time
'''

buckets = list() #save a seperate list of all buckets
prios = list() #save a list of all credits
buckets_taken = list() #create list of buckets taken to check against as to not pop buckets in class sort
for u in SAMPLE_USERS:
    buckets.append(u.buckets)
    prios.append(u.credits)
    bt = list()
    for b in u.buckets:
        bt.append(False)
    buckets_taken.append(bt)

results = list()
for i in range(TRIALS):
    r = 0
    #while r == 0:
    '''not needed anymore'''
    r = protosort.classsort(SAMPLE_USERS, SAMPLE_CLASSES, protosort.gen_test_map(buckets_taken))
    results.append(r)

scores = list()
bestindex = 0
for q in range(TRIALS):
    #print(results[q])
    scores.append(protosort.eval_cs(results[q], buckets, prios))
    #print(scores[q])
    if scores[q] > scores[bestindex]:
        bestindex = q

print scores[bestindex]
print [r.classes for r in results[bestindex]]
