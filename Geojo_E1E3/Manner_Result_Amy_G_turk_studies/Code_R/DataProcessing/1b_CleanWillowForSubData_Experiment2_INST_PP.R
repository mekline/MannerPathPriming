#install.packages(c("DPpackage", "ggplot2", "gsubfn","hexbin","languageR","lme4","MCMCglmm","multcomp","plyr","reshape","knitr","ez"))

library(ggplot2)
library(lme4)
library(MCMCglmm)
library(plyr)
library(reshape2)


## Data sets and functions with "Analyzing Linguistic Data: A practical intro to stats (Baayen)"
library(languageR)

## For Markov-Chain Monte Carlo estimation; need for library(R)
#library(coda)

## #Groupwise computations of summary statistics, general linear contrasts etc
library(doBy)

## #Linear and Nonlinear Mixed Effects Models
library(nlme)

## #Procedures for Psychological, Psychometric, and Personality
# use describe(pmdata) --> amazing!
library(psych)

require(stats)

# Data Import function
data_import = function(path_name){
list.files(path = path_name,full.names = T) -> file_list
data_import = c()
for (x in file_list) { 
  indiv_import<-read.delim(x, header = T)
 rbind(data_import,indiv_import) -> data_import
print(x)
  }
	return(data_import)
	}

#plyer
#shape
#################

df1 <- read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/10.24.13_Manner_Result_INSTmm/2013-10-24-18-45-01.csv", header = T)

df2 <- read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/10.24.13_Manner_Result_INSTmm/2013-10-24-22-08-30.csv", header = T)

df1and2AMT = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/10.24.13_Manner_Result_INSTmm/Batch_1306006_batch_results_Paper3_MannerResult_InstManners.csv", header = T)


mr1 = merge(df1, df1and2AMT, by.x = "PayCode", by.y= "Answer.paycode")
mr2 = merge(df2, df1and2AMT, by.x = "PayCode", by.y= "Answer.paycode")
mr1$WillowSubNo = as.factor(as.character(mr1$WillowSubNo))
mr2$WillowSubNo = as.factor(as.character(mr2$WillowSubNo))

## Change subject numbers for mr1 and mr2 so data sets can be combined w/o losing subjects
mr1.agg = aggregate(as.integer(mr1$trialNo), list(mr1$WillowSubNo), length)
colnames(mr1.agg) = c("WillowSubNo", "trialCount")
mr1.agg[1:4, ]

#change subject numbers so they run from 1 to the last subject in mr1
mr1.agg$WillowSubNo = as.factor(as.character(mr1.agg$WillowSubNo))
mr1.agg$SubNo = 1:nrow(mr1.agg)
unique(mr1.agg$SubNo)  #1-25


mr2.agg = aggregate(as.integer(mr2$trialNo), list(mr2$WillowSubNo), length)
colnames(mr2.agg) = c("WillowSubNo", "trialCount")
mr2.agg$SubNo = (1 + nrow(mr1.agg)): (nrow(mr1.agg) + nrow(mr2.agg))
unique(mr2.agg$SubNo) #26-54
#change subject numbers in mr2 so they start at 1 greater than last sub# in mr1 and continue in ascending order until the last subject in mr2


mr1 = merge(mr1, mr1.agg)
mr2 = merge(mr2, mr2.agg)

length(colnames(mr1))
length(colnames(mr2))
colnames(mr1)    #X1382640363300
colnames(mr2)	 #X1382652511861
##need to remove these columns before combining dataFrames-- they have different names & rbind requires an exact match on #column names in order to combine 
mr1$X1382640363300 = NULL
mr2$X1382652511861 = NULL

mannerResult = rbind(mr1, mr2)
unique(mannerResult$SubNo)   #1-54

mr1.agg$SubNo  # 1-25
mr2.agg$SubNo  # 26-54



df3 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/11.1.13_Run2/2013-11-01-15-55-48.csv", header = T)

amt3 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/11.1.13_Run2/Run2_Blocked_INST_Batch_1314135_batch_results.csv", header = T)

mr3 = merge(df3, amt3, by.x = "PayCode", by.y= "Answer.paycode")

mr3$WillowSubNo = as.factor(as.character(mr3$WillowSubNo))


## Change subject numbers for mr3 and mr2 so data sets can be combined w/o losing subjects
mr3.agg = aggregate(as.integer(mr3$trialNo), list(mr3$WillowSubNo), length)
colnames(mr3.agg) = c("WillowSubNo", "trialCount")

#change subject numbers so they run from 1 to the last subject in mr3
mr3.agg$WillowSubNo = as.factor(as.character(mr3.agg$WillowSubNo))
mr3.agg$SubNo = (max(mr2.agg$SubNo) +1) : (max(mr2.agg$SubNo) + nrow(mr3.agg))
unique(mr3.agg$SubNo)  #1-38
mr3 = merge(mr3, mr3.agg)

colnames(mr3)
##need to remove these columns before combining dataFrames-- they have different names & rbind requires an exact match on #column names in order to combine 
mr3$X1383321380439 = NULL

mannerResult = rbind(mannerResult, mr3)
# mannerResult[1:3, ]

df4 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/11.5.13_Run3/2013-11-05-20-01-25.csv", header = T)

amt4 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/11.5.13_Run3/Batch_1318473_batch_results.csv", header = T)

mr4 = merge(df4, amt4, by.x = "PayCode", by.y = "Answer.paycode")
mr4$WillowSubNo = as.factor(as.character(mr4$WillowSubNo))
mr4.agg = aggregate(as.integer(mr4$trialNo), list(mr4$WillowSubNo), length)
colnames(mr4.agg) = c("WillowSubNo", "trialCount")

#change subject numbers so they run from 1 to the last subject in mr3
mr4.agg$WillowSubNo = as.factor(as.character(mr4.agg$WillowSubNo))
mr4.agg$SubNo = (max(mr3.agg$SubNo) +1) : (max(mr3.agg$SubNo) + nrow(mr4.agg))
unique(mr4.agg$SubNo)  
mr4 = merge(mr4, mr4.agg)

colnames(mr4)
mr4$X1383681707223 = NULL  

mannerResult = rbind(mannerResult, mr4)

## NEW DATA: Collected April 4, 2014  (true for df5 & df6)
df5 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/4.4.14_INST_b1motionVL_b2CoS_N35/2014-04-04-13-15-11.csv", header = T)

amt5 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/4.4.14_INST_b1motionVL_b2CoS_N35/Batch_1480992_batch_results.csv", header = T)


mr5 = merge(df5, amt5, by.x = "PayCode", by.y = "Answer.paycode")
mr5$WillowSubNo = as.factor(as.character(mr5$WillowSubNo))
mr5.agg = aggregate(as.integer(mr5$trialNo), list(mr5$WillowSubNo), length)
colnames(mr5.agg) = c("WillowSubNo", "trialCount")

#change subject numbers so they run from 1 to the last subject in mr4
mr5.agg$WillowSubNo = as.factor(as.character(mr5.agg$WillowSubNo))
mr5.agg$SubNo = (max(mr4.agg$SubNo) +1) : (max(mr4.agg$SubNo) + nrow(mr5.agg))
unique(mr5.agg$SubNo)  
mr5 = merge(mr5, mr5.agg)

colnames(mr5)
mr5$X1396617328157 = NULL  
mr5[1:3, ]

mannerResult = rbind(mannerResult, mr5)

# length(colnames(mannerResult))
# unique(colnames(mannerResult)) == unique(colnames(mr5))

df6 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/4.4.14_INST_b1CoS_b2Motion_N25/2014-04-04-22-53-25.csv", header = T)

amt6 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/4.4.14_INST_b1CoS_b2Motion_N25/Batch_1481919_batch_results_10.4.14.csv", header = T)


mr6 = merge(df6, amt6, by.x = "PayCode", by.y = "Answer.paycode")
mr6$WillowSubNo = as.factor(as.character(mr6$WillowSubNo))
mr6.agg = aggregate(as.integer(mr6$trialNo), list(mr6$WillowSubNo), length)
colnames(mr6.agg) = c("WillowSubNo", "trialCount")

#change subject numbers so they run from 1 to the last subject in mr5
mr6.agg$WillowSubNo = as.factor(as.character(mr6.agg$WillowSubNo))
mr6.agg$SubNo = (max(mr5.agg$SubNo) +1) : (max(mr5.agg$SubNo) + nrow(mr6.agg))
unique(mr6.agg$SubNo)  
mr6 = merge(mr6, mr6.agg)

colnames(mr6)
mr6$X1396652021865 = NULL  

mannerResult = rbind(mannerResult, mr6)


setwd("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/dataMod_Blocked_INST")
list.files()

mannerResult$blockOrder = as.factor(as.character(mannerResult$blockOrder))
levels(mannerResult$blockOrder)
mannerResult$SubNo = as.factor(as.character(mannerResult$SubNo))
order(levels(mannerResult$SubNo))     #189 SUBJECTS 

mannerResult = mannerResult[order(mannerResult$SubNo, mannerResult$trialNo), ]

write.csv(mannerResult, "1_mannerResult_Blocked_INST_AllSub_.csv")

###########################################################################################################
unique(mannerResult$blockOrder)

length(unique(mannerResult$SubNo[mannerResult$blockOrder== "b1MannerOfMotion_b2Causal"]))  #51 Manner-of-motion
length(unique(mannerResult$SubNo[mannerResult$blockOrder== "b1Path_b2Causal"]))  #43 Path

length(unique(mannerResult$SubNo[mannerResult$blockOrder== "b1Means_b2Motion"]))  #43 Means
length(unique(mannerResult$SubNo[mannerResult$blockOrder== "b1Effect_b2Motion"]))  #52 Effect



##################### ALL RAW DATA FILES FOR EXPT 3.3 (INST) #################################

# df1 <- read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/10.24.13_Manner_Result_INSTmm/2013-10-24-18-45-01.csv", header = T)

# df2 <- read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/10.24.13_Manner_Result_INSTmm/2013-10-24-22-08-30.csv", header = T)

# df3 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/11.1.13_Run2/2013-11-01-15-55-48.csv", header = T)

# df4 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/11.5.13_Run3/2013-11-05-20-01-25.csv", header = T)

# df5 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/4.4.14_INST_b1motionVL_b2CoS_N35/2014-04-04-13-15-11.csv", header = T)

# df6 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/4.4.14_INST_b1CoS_b2Motion_N25/2014-04-04-22-53-25.csv", header = T)










