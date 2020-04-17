## Run this code to obtain the imputed, scaled and centered metabolite profile matrices for each time point

## Box layout coding

Coding = read.csv('03JUNE16_BOX LAYOUT_Bindley Code.csv',sep=',', header=TRUE)
Code = vector()
for(i in 1:length(Coding$MPF.Code)){
  if(Coding$MPF.Code[i]<10){
    Code[i] = paste("SA0",Coding$MPF.Code[i],"_1",".raw.",sep="")
  }
  else{
    Code[i] = paste("SA",Coding$MPF.Code[i],"_1",".raw.",sep="")
  }
}


Code_High_6mon = Code[which(Coding$Key=="high-6mo")]
Code_High_Day29 = Code[which(Coding$Key=="high-Day29")]
Code_High_Day8 = Code[which(Coding$Key=="high-Day8")]
Code_Low_6mon = Code[which(Coding$Key=="low-6mo")]
Code_Low_Day29 = Code[which(Coding$Key=="low-Day29")]
Code_Low_Day8 = Code[which(Coding$Key=="low-Day8")]

Patient_High_6mo = as.character(Coding$Patient[which(Coding$Key=="high-6mo")])
Patient_High_Day29 = as.character(Coding$Patient[which(Coding$Key=="high-Day29")])
Patient_High_Day8 = as.character(Coding$Patient[which(Coding$Key=="high-Day8")])
Patient_Low_6mo = as.character(Coding$Patient[which(Coding$Key=="low-6mo")])
Patient_Low_Day29 = as.character(Coding$Patient[which(Coding$Key=="low-Day29")])
Patient_Low_Day8 = as.character(Coding$Patient[which(Coding$Key=="low-Day8")])

##Extracting metabolite profile data and segregation

Met = read.csv('MetabolomicsFiltered.csv',sep=',',header=TRUE)
Met[Met == 1] <- NA

MetaboliteProfile = as.matrix.data.frame(Met[,2:105])
MetaboliteProfile_i = MetaboliteProfile
Met_High_6mo = MetaboliteProfile[,Code_High_6mon]
Met_High_Day29 = MetaboliteProfile[,Code_High_Day29]
Met_High_Day8 = MetaboliteProfile[,Code_High_Day8]
Met_Low_6mo = MetaboliteProfile[,Code_Low_6mon]
Met_Low_Day29 = MetaboliteProfile[,Code_Low_Day29]
Met_Low_Day8 = MetaboliteProfile[,Code_Low_Day8]

findmissing <- function(MetData){
  MissLength <- mat.or.vec(length(MetData[,1]),1)
  N=length(MetData[1,])
  for(i in 1:length(MetData[,1])){
    A=sum(is.na(MetData[i,]))/N
    if(A>=0.7){
    MissLength[i] = 0}
    else if(A<0.7 && A>=0.4){
      MissLength[i]=1
    }
    else{
      MissLength[i]=2
    }
  }
  return(MissLength)
}

MissGroup = mat.or.vec(length(MetaboliteProfile[,1]),6)
MissGroup[,1] = findmissing(Met_High_6mo)
MissGroup[,2] = findmissing(Met_High_Day29)
MissGroup[,3] = findmissing(Met_High_Day8)
MissGroup[,4] = findmissing(Met_Low_6mo)
MissGroup[,5] = findmissing(Met_Low_Day29)
MissGroup[,6] = findmissing(Met_Low_Day8)

MissGroupF = mat.or.vec(length(MissGroup[,1]),1)

for(i in 1:length(MissGroup[,1])){
  if(length(which(MissGroup[i,]==0))>=1){
    MissGroupF[i]=0
  }
  else if(length(which(MissGroup[i,]==1))>=1){
    MissGroupF[i]=1
  }
  else{
    MissGroupF[i]=2
  }
}


MetTemp1 = MetaboliteProfile_i[which(MissGroupF==0),]
MetTemp1[is.na(MetTemp1)] = 0
MetaboliteProfile_i[which(MissGroupF==0),] = MetTemp1


library(impute)
MetTemp2 = MetaboliteProfile_i[which(MissGroupF==2),]
MetTemp3 = impute.knn(MetTemp2, k=5)
X=as.matrix(MetTemp3$data)
MetaboliteProfile_i[which(MissGroupF==2),] = X


MetTemp4 = MetaboliteProfile_i[which(MissGroupF==1),]
MetTemp7=mat.or.vec(length(MetTemp4[,1]),length(MetTemp4[1,]))
for(i in 1:length(MetTemp4[,1])){
  MetTemp5 = MetTemp4
  MetTemp5[is.na(MetTemp5)] = 0
  MetTemp5[i,] = MetTemp4[i,]
  MetTemp6 = impute.knn(MetTemp5,k=5)
  Y=as.matrix(MetTemp6$data)
  MetTemp7[i,]=Y[i,]
}
MetaboliteProfile_i[which(MissGroupF==1),] = MetTemp7

VCR = read.csv('VincristineAmount.csv',sep=',',header=FALSE)
Code_VCR = vector()

for(i in 1:length(VCR$V1)){
  Code_VCR[i] = paste(VCR$V1[i],"_1.raw.",sep="")
}

VCRdf = data.frame(t(VCR$V2))
colnames(VCRdf) <- Code_VCR

MetaboliteProfile_i <- rbind(MetaboliteProfile_i,VCRdf)

## This is the imputated, scaled and centered metabolite profile matrix, including the vincristine amount as the last feature
MetaboliteProfile_i <- t(scale(t(MetaboliteProfile_i),center=TRUE,scale=TRUE))

Met_High_6mo_i = MetaboliteProfile_i[,Code_High_6mon]
Met_High_Day29_i = MetaboliteProfile_i[,Code_High_Day29]
Met_High_Day8_i = MetaboliteProfile_i[,Code_High_Day8]
Met_Low_6mo_i = MetaboliteProfile_i[,Code_Low_6mon]
Met_Low_Day29_i = MetaboliteProfile_i[,Code_Low_Day29]
Met_Low_Day8_i = MetaboliteProfile_i[,Code_Low_Day8]

## Following are the metabolite profile matrices for each time point
Met_6mo_i = as.matrix(cbind(Met_High_6mo_i,Met_Low_6mo_i))
Met_Day29_i = as.matrix(cbind(Met_High_Day29_i,Met_Low_Day29_i))
Met_Day8_i = as.matrix(cbind(Met_High_Day8_i,Met_Low_Day8_i))
