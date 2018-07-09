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

# from ipython pandas - after fixing dup subject names due to server, merge with AMT & demographic crit applied

df1 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/3_BlockedAgentive_DOframes/Blocked_AgentiveMM_DOframes/11.13.13_DOsentences_CausalToMotionOnly/2013-11-13-22-57-37.csv", header = T)

amt1 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/3_BlockedAgentive_DOframes/Blocked_AgentiveMM_DOframes/11.13.13_DOsentences_CausalToMotionOnly/Batch_1328155_batch_results_Blocked_DOs.csv", header = T)

mr1 = merge(df1, amt1, by.x = "PayCode", by.y= "Answer.paycode")
mr1$WillowSubNo = as.factor(as.character(mr1$WillowSubNo))

## Change subject numbers for mr1 and mr2 so data sets can be combined w/o losing subjects
mr1.agg = aggregate(as.integer(mr1$trialNo), list(mr1$WillowSubNo), length)
colnames(mr1.agg) = c("WillowSubNo", "trialCount")
#mr1.agg[1:4, ]

#change subject numbers so they run from 1 to the last subject in mr1
mr1.agg$WillowSubNo = as.factor(as.character(mr1.agg$WillowSubNo))
mr1.agg$SubNo = 1:nrow(mr1.agg)
unique(mr1.agg$SubNo)  #40

mr1 = merge(mr1, mr1.agg)
length(colnames(mr1))

df2 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/3_BlockedAgentive_DOframes/Blocked_AgentiveMM_DOframes/11.20.13_DOsentences_MotionToCausalOnly/2013-11-20-18-05-10.csv", header = T)

amt2 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/3_BlockedAgentive_DOframes/Blocked_AgentiveMM_DOframes/11.20.13_DOsentences_MotionToCausalOnly/Batch_1336036_batch_results.csv", header = T)

mr2 = merge(df2, amt2, by.x = "PayCode", by.y = "Answer.paycode")
mr2$WillowSubNo = as.factor(as.character(mr2$WillowSubNo))
mr2.agg = aggregate(as.integer(mr2$trialNo), list(mr2$WillowSubNo), length)
colnames(mr2.agg) = c("WillowSubNo", "trialCount")
#mr2.agg[1:4, ]
mr2.agg$WillowSubNo = as.factor(as.character(mr2.agg$WillowSubNo))
mr2.agg$SubNo = (nrow(mr1.agg) + 1): (nrow(mr1.agg) + nrow(mr2.agg))
unique(mr2.agg$SubNo) #41-79
mr2 = merge(mr2, mr2.agg)

df3 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/3_BlockedAgentive_DOframes/Blocked_AgentiveMM_DOframes/11.20.13_DOsentences_Run2_AllCond/2013-11-20-02-12-31.csv", header = T)

amt3 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/3_BlockedAgentive_DOframes/Blocked_AgentiveMM_DOframes/11.20.13_DOsentences_Run2_AllCond/Batch_1335199_batch_results_blocked_DO_Run2.csv", header = T)

mr3 = merge(df3, amt3, by.x = "PayCode", by.y = "Answer.paycode")
mr3$WillowSubNo = as.factor(as.character(mr3$WillowSubNo))
mr3.agg = aggregate(as.integer(mr3$trialNo), list(mr3$WillowSubNo), length)
colnames(mr3.agg) = c("WillowSubNo", "trialCount")
#mr3.agg[1:4, ]
mr3.agg$WillowSubNo = as.factor(as.character(mr3.agg$WillowSubNo))
mr3.agg$SubNo = (max(mr2.agg$SubNo) +1) : (max(mr2.agg$SubNo) + nrow(mr3.agg))
unique(mr3.agg$SubNo) #80-119
mr3 = merge(mr3, mr3.agg)

df4 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/3_BlockedAgentive_DOframes/Blocked_AgentiveMM_DOframes/12.2.13_DOsentences_AllCond/2013-12-03-01-30-48.csv", header = T)

df5 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/3_BlockedAgentive_DOframes/Blocked_AgentiveMM_DOframes/12.2.13_DOsentences_AllCond/2013-12-03-21-35-39.csv", header = T)

amt4and5 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/3_BlockedAgentive_DOframes/Blocked_AgentiveMM_DOframes/12.2.13_DOsentences_AllCond/Batch_1348281_batch_results_12.2.13_DOagentive.csv", header = T)

mr4 = merge(df4, amt4and5, by.x = "PayCode", by.y = "Answer.paycode")
mr4$WillowSubNo = as.factor(as.character(mr4$WillowSubNo))
mr4.agg = aggregate(as.integer(mr4$trialNo), list(mr4$WillowSubNo), length)
colnames(mr4.agg) = c("WillowSubNo", "trialCount")
#mr4.agg[1:4, ]
mr4.agg$WillowSubNo = as.factor(as.character(mr4.agg$WillowSubNo))
mr4.agg$SubNo = (max(mr3.agg$SubNo) +1) : (max(mr3.agg$SubNo) + nrow(mr4.agg))
unique(mr4.agg$SubNo) #120-172
mr4 = merge(mr4, mr4.agg)

mr5 = merge(df5, amt4and5, by.x = "PayCode", by.y = "Answer.paycode")
mr5$WillowSubNo = as.factor(as.character(mr5$WillowSubNo))
mr5.agg = aggregate(as.integer(mr5$trialNo), list(mr5$WillowSubNo), length)
colnames(mr5.agg) = c("WillowSubNo", "trialCount")
#mr5.agg[1:4, ]
mr5.agg$WillowSubNo = as.factor(as.character(mr5.agg$WillowSubNo))
mr5.agg$SubNo = (max(mr4.agg$SubNo) +1) : (max(mr4.agg$SubNo) + nrow(mr5.agg))
unique(mr5.agg$SubNo) # 173-176  (last = 176)
mr5 = merge(mr5, mr5.agg)

colnames(mr1)
colnames(mr2)
colnames(mr3)
colnames(mr4)
colnames(mr5)

mr1$X1384383489727 <- NULL
mr2$X1384970746798 <- NULL
mr3$X1384913561168 <- NULL
mr4$X1386034267214 <- NULL
mr5$X1386106546619 <- NULL

mannerResult = rbind(mr1, mr2)
mannerResult = rbind(mannerResult, mr3)
mannerResult = rbind(mannerResult, mr4)
mannerResult = rbind(mannerResult, mr5)
length(unique(mannerResult$SubNo))   #176 subjects post merge; 4 conditions-- so should be ~44each 

setwd("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/3_BlockedAgentive_DOframes/dataMod_Blocked_Agentive_DOsentences")

list.files()

###### START AFTER FIXING DATA ISSUES -- CODE ABOVE IS NOT ORDERED WELL ########

mannerResult$SubNo = as.factor(as.character(mannerResult$SubNo))
order(levels(mannerResult$SubNo))

mannerResult = mannerResult[order(mannerResult$SubNo, mannerResult$trialNo), ]

write.csv(mannerResult, "1_mannerResult_AllSub.csv")