# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a script file developed by Ioanna Pasiopoulou & Irene- Maria Tabakis.
"""
#import keras
from keras.applications.resnet50 import ResNet50
from keras.preprocessing import image
from keras.applications.resnet50 import preprocess_input, decode_predictions
import numpy as np
model = ResNet50(weights='imagenet')

# classify the images
img_path=[]
for x in range(12):
    s= 'image'+str(x+1)+'.jpg' 
    img_path.append(s)
for x in range(12):
    print(img_path[x])
    img = image.load_img(img_path[x], target_size=(224, 224))
    x = image.img_to_array(img)
    x = np.expand_dims(x, axis=0)
    x = preprocess_input(x)
    preds = model.predict(x)    
    print('Predicted:', decode_predictions(preds, top=3)[0])