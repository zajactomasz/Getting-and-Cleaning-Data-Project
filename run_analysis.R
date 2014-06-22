library("data.table");

#read train dataset
train<-read.table("train/X_train.txt");
train[,562]<-read.table("train/y_train.txt");
train[,563]<-read.table("train/subject_train.txt");

#read test dataset
test<-read.table("test/X_test.txt");
test[,562]<-read.table("test/y_test.txt");
test[,563]<-read.table("test/subject_test.txt");

#merge these two
merged=rbind(train,test);

#reading features, and get rid od braces and pauses, uppercase
feats<-read.table("features.txt");
feats[,2]=gsub('[-()]','',feats[,2]);
feats[,2]=gsub('std','Std',feats[,2]);
feats[,2]=gsub('mean','Mean',feats[,2]);

#filter & save Mean and Std rows, they will be cols
meanstdcols<-grep(".*Mean.*|.*Std.*",feats[,2]);
feats<-feats[meanstdcols,];

#now they're cols
meanstdcols=c(meanstdcols,562,563);
merged<-merged[,meanstdcols];

#add colnames, feature names, 
colnames(merged)<-c(feats$V2,"Activity","Subject");

#read activities
activs<-read.table("activity_labels.txt");
#we need the activity name
actnum=1;
for(cAct in activs$V2){
  merged$Activity<-gsub(actnum,cAct,merged$Activity);
  actnum=actnum+1;
}

#coerce to factors
merged$Activity<-as.factor(merged$Activity);
merged$Subject<-as.factor(merged$Subject);

#calculate avg
data=aggregate(merged,by=list(Activity=merged$Activity,Subject=merged$Subject),mean)
data[,90]=NULL; #no use for this column anymore
data[,89]=NULL; #same..
write.table(data,"TidyDataSet.txt",sep=";"); #write the table







