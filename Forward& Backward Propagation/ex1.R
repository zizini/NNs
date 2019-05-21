#library(ggplot2)
#library(plyr)
#library(ROCR)
library(dplyr)

#Load data
adult <- read.table('https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data', sep = ',', fill = F, strip.white = T)

#Explore data
class(adult)
dim(adult)
names(adult)

str(adult)
#glimpse(adult)

head(adult)
tail(adult)

colnames(adult) <- c('Age', 'WorkClass', 'FnlWgt', 'Education','EducationYears', 'MaritalStatus', 'Occupation', 'Relationship', 'Race', 'Sex','CapitalGain', 'CapitalLoss', 'HoursWeek', 'NativeCountry', 'Income')
names(adult)

#----Pre-processing---#

#Classifing age
#http://www.pgagroup.com/standardized-survey-classifications.html
#https://www.statcan.gc.ca/eng/concepts/definitions/age2

#Ages to categories
barplot(table(adult$Age), main = "Age Continuous")
attach(adult)
adult$AgeCategories[Age >= 15 & Age < 25] <- "15-24"
adult$AgeCategories[Age >= 25 & Age < 35] <- "25-34"
adult$AgeCategories[Age >= 35 & Age < 45] <- "35-44"
adult$AgeCategories[Age >= 45 & Age < 55] <- "45-54"
adult$AgeCategories[Age >= 55 & Age < 65] <- "55-64"
adult$AgeCategories[Age >= 65] <- "65+"
detach(adult)
adult$AgeCategories <- as.factor(adult$AgeCategories)
class(adult$AgeCategories)
summary(adult)
barplot(table(adult$AgeCategories), main = "Age Categories")


#Delete of feature columns
adult$Age<-NULL
adult$FnlWgt<-NULL
adult$EducationYears<-NULL

#Reduce Education categories
adult$Education = as.character(adult$Education)
glimpse(adult)
adult$Education = gsub("^Preschool","UnComStd",adult$Education)
adult$Education = gsub("^1st-4th","UnComStd",adult$Education)
adult$Education = gsub("^5th-6th","UnComStd",adult$Education)
adult$Education = gsub("^7th-8th","UnComStd",adult$Education)
adult$Education = gsub("^9th","UnComStd",adult$Education)
adult$Education = gsub("^10th","UnComStd",adult$Education)
adult$Education = gsub("^11th","UnComStd",adult$Education)
adult$Education = gsub("^12th","UnComStd",adult$Education)
adult$Education = gsub("^Assoc-acdm","Associates",adult$Education)
adult$Education = gsub("^Assoc-voc","Associates",adult$Education)
adult$Education = gsub("^HS-Grad","GraduateHS",adult$Education)
adult$Education = gsub("^Some-college","Associates",adult$Education)
adult$Education <- as.factor(adult$Education)
summary(adult$Education)


#edw kaname
#plot(adult$MaritalStatus,adult$Income)

#Reduce Marital Status categories
adult$MaritalStatus = as.character(adult$MaritalStatus)
adult$MaritalStatus[adult$MaritalStatus=="Married-AF-spouse"] = "Married"
adult$MaritalStatus[adult$MaritalStatus=="Married-civ-spouse"] = "Married"
adult$MaritalStatus[adult$MaritalStatus=="Married-spouse-absent"] = "Married"
adult$MaritalStatus <- as.factor(adult$MaritalStatus)
summary(adult$MaritalStatus)


#Reduce Work Class categories
adult$WorkClass = as.character(adult$WorkClass)

adult$WorkClass = gsub("^Federal-gov","Goverment",adult$WorkClass)
adult$WorkClass = gsub("^Local-gov","Goverment",adult$WorkClass)
adult$WorkClass = gsub("^State-gov","Goverment",adult$WorkClass)

adult$WorkClass = gsub("^Self-emp-inc","SelfEmp",adult$WorkClass)
adult$WorkClass = gsub("^Self-emp-not","SelfEmp",adult$WorkClass)
adult$WorkClass = gsub("^SelfEmp-inc","SelfEmp",adult$WorkClass)

adult$WorkClass = gsub("^Without-pay","Unknown",adult$WorkClass)
adult$WorkClass = gsub("^Never-worked","Unknown",adult$WorkClass)
adult$WorkClass = gsub("^Unknown","Other/Unknown",adult$WorkClass)
adult$WorkClass[adult$WorkClass=="?"] = "Other/Unknown"

adult$WorkClass <- as.factor(adult$WorkClass)


#Reduce Occupation categories
adult$Occupation = as.character(adult$Occupation)
adult$Occupation = gsub("^Adm-clerical","Admin",adult$Occupation)
adult$Occupation = gsub("^Armed-Forces","Other/Unknown",adult$Occupation)
adult$Occupation = gsub("^Craft-repair","BlueCollar",adult$Occupation)
adult$Occupation = gsub("^Exec-managerial","WhiteCollar",adult$Occupation)
adult$Occupation = gsub("^Farming-fishing","BlueCollar",adult$Occupation)
adult$Occupation = gsub("^Handlers-cleaners","BlueCollar",adult$Occupation)
adult$Occupation = gsub("^Machine-op-inspct","BlueCollar",adult$Occupation)
adult$Occupation = gsub("^Other-service","Service",adult$Occupation)
adult$Occupation = gsub("^Priv-house-serv","Service",adult$Occupation)
adult$Occupation = gsub("^Prof-specialty","Professional",adult$Occupation)
adult$Occupation = gsub("^Protective-serv","Service",adult$Occupation)
adult$Occupation = gsub("^Sales","Sales",adult$Occupation)
adult$Occupation = gsub("^Tech-support","Service",adult$Occupation)
adult$Occupation = gsub("^Transport-moving","BlueCollar",adult$Occupation)
adult$Occupation[adult$Occupation=="?"] = "Other/Unknown"
adult$Occupation <- as.factor(adult$Occupation)


#Hours per Week to categories
attach(adult)
adult$HoursWeek[HoursWeek >= 0 & HoursWeek < 25] <- "PartTime"
adult$HoursWeek[HoursWeek >= 25 & HoursWeek < 40] <- "FullTime"
adult$HoursWeek[HoursWeek >= 40 & HoursWeek < 60] <- "OverTime"
adult$HoursWeek[HoursWeek >= 60] <- "TooMuch"
detach(adult)
adult$HoursWeek <- as.factor(adult$HoursWeek)
class(adult$HoursWeek)
summary(adult)


#Reduce Native Country categories
adult$NativeCountry = as.character(adult$NativeCountry)
adult$NativeCountry = gsub("^Canada","Canada",adult$NativeCountry)
adult$NativeCountry = gsub("^Mexico","Mexico",adult$NativeCountry)
adult$NativeCountry = gsub("^United-States","USA",adult$NativeCountry)
adult$NativeCountry = gsub("^Outlying-US(Guam-USVI-etc)","USA",adult$NativeCountry)
adult$NativeCountry = gsub("^Cuba","OtherNA",adult$NativeCountry)
adult$NativeCountry = gsub("^Dominican-Republic","OtherNA",adult$NativeCountry)
adult$NativeCountry = gsub("^El-Salvador","OtherNA",adult$NativeCountry)
adult$NativeCountry = gsub("^Guatemala","OtherNA",adult$NativeCountry)
adult$NativeCountry = gsub("^Haiti","OtherNA",adult$NativeCountry)
adult$NativeCountry = gsub("^Honduras","OtherNA",adult$NativeCountry)
adult$NativeCountry = gsub("^Jamaica","OtherNA",adult$NativeCountry)
adult$NativeCountry = gsub("^Nicaragua","OtherNA",adult$NativeCountry)
adult$NativeCountry = gsub("^Puerto-Rico","OtherNA",adult$NativeCountry)
adult$NativeCountry = gsub("^Trinadad&Tobago","OtherNA",adult$NativeCountry)
adult$NativeCountry = gsub("^Columbia","SA",adult$NativeCountry)
adult$NativeCountry = gsub("^Ecuador","SA",adult$NativeCountry)
adult$NativeCountry = gsub("^Peru","SA",adult$NativeCountry)
adult$NativeCountry = gsub("^Cambodia","Asia",adult$NativeCountry)
adult$NativeCountry = gsub("^China","Asia",adult$NativeCountry)
adult$NativeCountry = gsub("^India","Asia",adult$NativeCountry)
adult$NativeCountry = gsub("^Iran","Asia",adult$NativeCountry)
adult$NativeCountry = gsub("^Japan","Asia",adult$NativeCountry)
adult$NativeCountry = gsub("^Laos","Asia",adult$NativeCountry)
adult$NativeCountry = gsub("^Philippines","Asia",adult$NativeCountry)
adult$NativeCountry = gsub("^Taiwan","Asia",adult$NativeCountry)
adult$NativeCountry = gsub("^Thailand","Asia",adult$NativeCountry)
adult$NativeCountry = gsub("^Vietnam","Asia",adult$NativeCountry)
adult$NativeCountry = gsub("^England","Europe",adult$NativeCountry)
adult$NativeCountry = gsub("^France","Europe",adult$NativeCountry)
adult$NativeCountry = gsub("^Germany","Europe",adult$NativeCountry)
adult$NativeCountry = gsub("^Greece","Europe",adult$NativeCountry)
adult$NativeCountry = gsub("^Holand-Netherlands","Europe",adult$NativeCountry)
adult$NativeCountry = gsub("^Hong","Europe",adult$NativeCountry)
adult$NativeCountry = gsub("^Hungary","Europe",adult$NativeCountry)
adult$NativeCountry = gsub("^Ireland","Europe",adult$NativeCountry)
adult$NativeCountry = gsub("^Italy","Europe",adult$NativeCountry)
adult$NativeCountry = gsub("^Poland","Europe",adult$NativeCountry)
adult$NativeCountry = gsub("^Portugal","Europe",adult$NativeCountry)
adult$NativeCountry = gsub("^Scotland","Europe",adult$NativeCountry)
adult$NativeCountry = gsub("^South","Europe",adult$NativeCountry)
adult$NativeCountry = gsub("^Yugoslavia","Europe",adult$NativeCountry)
adult$NativeCountry[adult$NativeCountry=="?"] = "Other/Unknown"
adult$NativeCountry <- as.factor(adult$NativeCountry)


adult$NativeCountry = as.character(adult$NativeCountry)
adult$NativeCountry = gsub("^United-States","USA",adult$NativeCountry)
adult$NativeCountry = gsub("^OtherNA Outlying-US(Guam-USVI-etc)","USA",adult$NativeCountry)
adult$NativeCountry = gsub("^South","nonUSA",adult$NativeCountry)
adult$NativeCountry = gsub("^SA","nonUSA",adult$NativeCountry)
adult$NativeCountry = gsub("^Other/Unknown","nonUSA",adult$NativeCountry)
adult$NativeCountry = gsub("^Mexico","nonUSA",adult$NativeCountry)
adult$NativeCountry = gsub("^Canada","nonUSA",adult$NativeCountry)
adult$NativeCountry = gsub("^Asia","nonUSA",adult$NativeCountry)
adult$NativeCountry = gsub("^Europe","nonUSA",adult$NativeCountry)
adult$NativeCountry = as.character(adult$NativeCountry)
summary(adult$NativeCountry)
adult$NativeCountry = as.factor(adult$NativeCountry)
summary(adult$NativeCountry)
adult$NativeCountry = as.character(adult$NativeCountry)
adult$NativeCountry = gsub("^OtherNA","nonUSA",adult$NativeCountry)
adult$NativeCountry = gsub("^Outlying-US","nonUSA",adult$NativeCountry)
adult$NativeCountry = as.factor(adult$NativeCountry)
summary(adult$NativeCountry)
adult$NativeCountry = as.character(adult$NativeCountry)
adult$NativeCountry[adult$NativeCountry=="nonUSA(Guam-USVI-etc)"] = "nonUSA"
adult$NativeCountry = as.factor(adult$NativeCountry)
summary(adult$NativeCountry)


#Capital to categories
adult$Capital<-adult$CapitalGain-adult$CapitalLoss
View(adult)
attach(adult)
adult$Capital[Capital < 0] <- "Loss"
adult$Capital[Capital > 0] <- "Gain"
adult$Capital[Capital == 0] <-"Zero"
detach(adult)
adult$Capital <- as.factor(adult$Capital)
class(adult$Capital)

adult$CapitalGain<-NULL
adult$CapitalLoss<-NULL


#forward
sz <- round(.75 * dim(adult)[1])  # training set size
training_set <- adult[1:sz,]
testing_set <- adult[-(1:sz),]
View(training_set)
View(testing_set)

library(caret)
library(nnet)
library(MLmetrics)
nn1 <- nnet(Income ~ ., data = training_set, wgt=1, size = 9, maxit = 300)
# weights:  379
#initial  value 19056.618176 
#iter  10 value 9069.040599
#iter  20 value 8226.544486
#iter  30 value 8040.287091
#iter  40 value 7931.725239
#iter  50 value 7892.537988
#iter  60 value 7866.863134
#iter  70 value 7838.250588
#iter  80 value 7813.070671
#iter  90 value 7793.479363
#iter 100 value 7757.318745
#iter 110 value 7708.356084
#iter 120 value 7677.837067
#iter 130 value 7654.885135
#iter 140 value 7638.451180
#iter 150 value 7625.630438
#iter 160 value 7617.353350
#iter 170 value 7609.175244
#iter 180 value 7596.293925
#iter 190 value 7584.030846
#iter 200 value 7574.098345
#iter 210 value 7566.462126
#iter 220 value 7561.024560
#iter 230 value 7556.985791
#iter 240 value 7552.567840
#iter 250 value 7545.762219
#iter 260 value 7540.135129
#iter 270 value 7535.172266
#iter 280 value 7527.967495
#iter 290 value 7520.820207
#iter 300 value 7513.978901
#final  value 7513.978901 
#stopped after 300 iterations

#Prediction in training data
nn1.pred.train <- predict(nn1, newdata = training_set, type = 'raw')
pred1.train <- rep('<=50K', length(nn1.pred.train))
pred1.train[nn1.pred.train>=.5] <- '>50K'

Accuracy(pred1.train, training_set$Income)
#0.8511936
Precision(training_set$Income,pred1.train)
#[1] 0.8847496
Recall(training_set$Income,pred1.train)
#[1] 0.9285868
F1_Score(training_set$Income,pred1.train)
#[1] 0.9061383

#Prediction in testing data
nn1.pred.train <- predict(nn1, newdata = testing_set, type = 'raw')
pred1 <- rep('<=50K', length(nn1.pred))
pred1[nn1.pred>=.5] <- '>50K'
# confusion matrix 
tb1 <- table(pred1, testing_set$Income)
Accuracy(pred1,testing_set$Income)
#0.8399263
Precision(testing_set$Income,pred1)
#[1] 0.8757977
Recall(testing_set$Income, pred1)
#[1] 0.9146619
F1_Score(testing_set$Income, pred1)
#[1] 0.894808

#Back
library(nnet)
library(neuralnet)
library(caret)
library(lattice)
library(ggplot2)
library(caret)
library(neuralnet)
library(MLmetrics)

#Data preparing
itrain <- adult

itrain$Over50 <- c(itrain$Income == ">50K")
itrain$Less50 <- c(itrain$Income == "<=50K")

var1.matrix <- model.matrix(~ WorkClass+Education+MaritalStatus+Occupation+Relationship+Race+Sex+HoursWeek+NativeCountry+AgeCategories+Over50+Less50, data = itrain)
itrain_numeric <- data.frame(var1.matrix)

n <-names(itrain_numeric)
f<-as.formula(paste("Income ~", paste(n[!n %in% "Income"], collapse = " + ")))

set.seed(1234)
sz2 <- round(.75 * dim(adult)[1])
training_set2 <- itrain_numeric[1:sz2,]
testing_set2 <- itrain_numeric[-(1:sz2),]


#Model learning
nn2 <- neuralnet(Over50TRUE + Less50TRUE ~ X.Intercept. + WorkClassOther.Unknown + WorkClassPrivate +
                   +                       WorkClassSelfEmp + EducationBachelors + EducationDoctorate +
                   +                       EducationHS.grad + EducationMasters + EducationProf.school +
                   +                       EducationUnComStd + MaritalStatusMarried + MaritalStatusNever.married +
                   +                       MaritalStatusSeparated + MaritalStatusWidowed + OccupationBlueCollar +
                   +                       OccupationOther.Unknown + OccupationProfessional + OccupationSales +
                   +                       OccupationService + OccupationWhiteCollar + RelationshipNot.in.family +
                   +                       RelationshipOther.relative + RelationshipOwn.child + RelationshipUnmarried +
                   +                       RelationshipWife + RaceAsian.Pac.Islander + RaceBlack + RaceOther +
                   +                       RaceWhite + SexMale + HoursWeekOverTime + HoursWeekPartTime +
                   +                       HoursWeekTooMuch + NativeCountryUSA + AgeCategories25.34 +
                   +                       AgeCategories35.44 + AgeCategories45.54 + AgeCategories55.64 +
                   +                       AgeCategories65., data = training_set2, hidden=3, lifesign ="full", threshold = 0.16)

plot(nn2)

#Prediction in testing_set
pred <- compute(nn2, testing_set2[,1:39])
result<-0
for (i in 1:8140) {
  result[i] <- which.max(pred$net.result[i,])
  if (result[i]==1) {result[i] = "<=50K"}
  else if (result[i]==2) {result[i] = ">50"}
}

table(true=testing_set$Income, predicted=result)

Accuracy(result, testing_set$Income)
#[1] 0.6966830467

Precision(testing_set$Income,result)
#[1] 0.8684532925

Recall(testing_set$Income, result)
#[1] 0.9218140442

F1_Score(testing_set$Income, result)
#[1] 0.8943384324


#Prediction in training_set
pred.train <- compute(nn2, training_set2[,1:39])
result<-0
for (i in 1:24421) {
  result[i] <- which.max(pred.train$net.result[i,])
  if (result[i]==1) {result[i] = "<=50K"}
  else if (result[i]==2) {result[i] = ">50"}
}

table(true=training_set$Income, predicted=result)

Accuracy(result, training_set$Income)
#[1] 0.7052536751

Precision(training_set$Income,result)
#[1] 0.8677448609

Recall(training_set$Income, result)
#[1] 0.9275635502

F1_Score(training_set$Income, result)
#[1] 0.8966576426



