import numpy as np

import cv2
from keras.preprocessing import image as image_utils
from keras.models import load_model


# load weights into new model
classifier = load_model('our_model.h5')
print("Loaded model from disk")

correct_counter = 0
correct_label=0
imagePaths =[
             'C:\\Users\\User\\.spyder-py3\\IoannaPassiopoulou_IreneMariaTabakis_Ex2\\bus.jpg',
             'C:\\Users\\User\\.spyder-py3\\IoannaPassiopoulou_IreneMariaTabakis_Ex2\\bottle_or_bus.jpg'] #list(paths.list_images(args["image"]))

print('Testing {}'.format(len(imagePaths)))
for i in imagePaths:
    orig = cv2.imread(i)
    if 'bottle' in i:
        correct_label = 0
    if 'bus' in i:
        correct_label = 1
        
    orig = cv2.imread(i)
	 #print("[INFO] loading and preprocessing image...")
    image = image_utils.load_img(i, target_size=(64, 64))
    image = image_utils.img_to_array(image)
    image = np.expand_dims(image, axis=0)
    
    predictions = classifier.predict(image,verbose=0)
    print(predictions)
    
    if(predictions[0, 0] >= 0.5):
        if(correct_label==1):
            correct_counter = correct_counter + 1 
            print('I am {:.2%} sure this is a Bus'.format(predictions[0][0]))
            cv2.putText(orig, "Prediction: {}".format('Bus'), (10, 30),cv2.FONT_HERSHEY_SIMPLEX, 0.9, (255, 0,0), 2)
        else:
            print ("Wrongly classified as Bus")
    else:
        if correct_label == 0:
            correct_counter = correct_counter + 1 
            print('I am {:.2%} sure this is a Bottle'.format(1-predictions[0][0]))
            cv2.putText(orig, "Prediction: {}".format('Bottle'), (10, 30),cv2.FONT_HERSHEY_SIMPLEX, 0.9, (255, 0,0), 2)
        else:
            print ("Wrongly classified as Bottle")
    print("[==============================]")
    cv2.namedWindow("Classification")
    cv2.moveWindow("Classification",100 , 100)
    cv2.imshow("Classification", orig)
    cv2.waitKey(0)

print('Number of correctly classified images {}'.format(correct_counter))