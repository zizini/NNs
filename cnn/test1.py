# -*- coding: utf-8 -*-
"""
Created on Sun Feb  4 15:40:58 2018

@author: User
"""

import numpy as np
from keras.preprocessing import image
test_image = image.load_img('C:\\Users\\User\\.spyder-py3\\IoannaPassiopoulou_IreneMariaTabakis_Ex2\\bottle.jpg', target_size = (64, 64))
test_image = image.img_to_array(test_image)
test_image = np.expand_dims(test_image, axis = 0)
result = model.predict(test_image)
#training_set.class_indices
if result[0][0] == 0:
    prediction = 'bottle'
else:
    prediction = 'bus'

print (prediction)


