## Run MissingDataImputation.R first
## Run this code to perform SVM-based feature selection. This will need CARET package installed.
## You can change the CARET parameters and the number of iterations (Niter) as you like.

## For Day 8
Y=c(rep(1,24),rep(-1,8))
## For Day 29 and month 6
## Y=c(rep(1,24),rep(-1,8)) 
Y[Y==-1]<-"Low"
Y[Y==1]<-"High"

Yf<-factor(Y)


## For Day 8. Load Day 29 (Met_Day29_i) and month 6 (Met_6mo_i) data appropriately.
Met1 <- t(as.matrix(Met_Day8_i))

########Recursive feature selection

library(caret)

##Parallel computing
library(doSNOW)
cl <- makeCluster(7, type="SOCK", outfile="")
registerDoSNOW(cl)
caretFuncs$summary <- twoClassSummary


control <- rfeControl(functions=caretFuncs, method="repeatedcv", number=5, repeats=20)

trainctrl <- trainControl(classProbs = TRUE, summaryFunction = twoClassSummary)


Xdf=data.frame(Met1)

Niter=100
ROCList=mat.or.vec(Niter+1,1)
SpecSDList=mat.or.vec(Niter+1,1)
PList = mat.or.vec(Niter+1,1)
results <- rfe(Xdf, Yf, sizes=c(1:50), rfeControl = control, method = "svmLinear2", tuneLength = 1, trControl = trainctrl, metric = "ROC")
ROC = results$fit$results$ROC
SpecSD = results$fit$results$SpecSD
ROCList[1]=ROC
SpecSDList[1]=SpecSD
Ptemp = predictors(results)
PList[1] = length(Ptemp)

for(i in 1:Niter){
  results2 <- rfe(Xdf, Yf, sizes=c(1:50), rfeControl = control, method = "svmLinear2", tuneLength = 1, trControl = trainctrl, metric = "ROC")
  ROC2 = results2$fit$results$ROC
  SpecSD2 = results2$fit$results$SpecSD
  Ptemp = predictors(results2)
  ROCList[i+1] = ROC2
  SpecSDList[i+1] = SpecSD2
  PList[i+1] = length(Ptemp)
  
  if(ROC2>ROC && SpecSD2<=SpecSD){
    results=results2
    ROC=ROC2
    SpecSD=SpecSD2
  }
  print(i)
}

ROC = results$fit$results$ROC
Spec = results$fit$results$Spec
Sens = results$fit$results$Sens
ROCSD = results$fit$results$ROCSD
SensSD = results$fit$results$SensSD
SpecSD = results$fit$results$SpecSD
Ptemp = predictors(results)


stopCluster(cl)
registerDoSEQ()

print(results)
predictors(results)
plot(results,type=c("g","o"))