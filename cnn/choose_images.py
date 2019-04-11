# -*- coding: utf-8 -*-
"""
Created on Sat Feb  3 00:17:30 2018

@author: User
"""

import os
import shutil

#bottle train
filepath='C:\\Users\\User\\Desktop\\bottle_train.txt'
lines = [ line.strip().split(" ") for line in open(filepath)]
my_list_len = len(lines)
for i in range(0, my_list_len):
   # print (lines[i][2])
   if (lines[i][1] != '-1') and (lines[i][1] != '0'):
       filename='C:\\Users\\User\\Desktop\\JPEGImages\\'+lines[i][0]+".jpg"
       print (filename)
       if (os.path.isfile(filename)):
           shutil.copy(filename, 'C:\\Users\\User\\Desktop\\bottle_train\\')
           
           
#bottle val
filepath='C:\\Users\\User\\Desktop\\bottle_val.txt'
lines = [ line.strip().split(" ") for line in open(filepath)]

my_list_len = len(lines)
for i in range(0, my_list_len):
   # print (lines[i][2])
   if (lines[i][1] != '-1') and (lines[i][1] != '0'):
       filename='C:\\Users\\User\\Desktop\\JPEGImages\\'+lines[i][0]+".jpg"
       print (filename)
       if (os.path.isfile(filename)):
           shutil.copy(filename, 'C:\\Users\\User\\Desktop\\bottle_val\\')

#bus train
filepath='C:\\Users\\User\\Desktop\\bus_train.txt'
lines = [ line.strip().split(" ") for line in open(filepath)]

my_list_len = len(lines)
for i in range(0, my_list_len):
   # print (lines[i][2])
   if (lines[i][1] != '-1') and (lines[i][1] != '0'):
       filename='C:\\Users\\User\\Desktop\\JPEGImages\\'+lines[i][0]+".jpg"
       print (filename)
       if (os.path.isfile(filename)):
           shutil.copy(filename, 'C:\\Users\\User\\Desktop\\bus_train\\')
           
#bus val
filepath='C:\\Users\\User\\Desktop\\bus_val.txt'
lines = [ line.strip().split(" ") for line in open(filepath)]

my_list_len = len(lines)
for i in range(0, my_list_len):
   # print (lines[i][2])
   if (lines[i][1] != '-1') and (lines[i][1] != '0'):
       filename='C:\\Users\\User\\Desktop\\JPEGImages\\'+lines[i][0]+".jpg"
       print (filename)
       if (os.path.isfile(filename)):
           shutil.copy(filename, 'C:\\Users\\User\\Desktop\\bus_val\\')