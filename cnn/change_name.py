# -*- coding: utf-8 -*-
"""
Created on Sat Feb  3 18:32:17 2018

@author: User
"""

import os

path = 'C:\\Users\\User\\Desktop\\data\\train\\bottle'
i = 0
for filename in os.listdir(path):
    os.rename(os.path.join(path,filename), os.path.join(path,'bottle.'+str(i)+'.jpg'))
    i = i +1