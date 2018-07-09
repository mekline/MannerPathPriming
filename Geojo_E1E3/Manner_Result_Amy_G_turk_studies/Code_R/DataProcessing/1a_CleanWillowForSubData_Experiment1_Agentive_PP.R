#install.packages(c("DPpackage", "ggplot2", "gsubfn","hexbin","languageR","lme4","MCMCglmm","multcomp","plyr","reshape","knitr","ez"))

library(ggplot2)
library(lme4)
library(MCMCglmm)
library(plyr)
library(reshape)


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
# df1 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/3_Manner-Result_Paper3/0_Data_AMT/10.1.13_MannerResult_Blocked_and_Interspersed/analyses_MannerResult_Blocked/rawData/2013-09-26-16-34-53_Blocked_N80a.csv", header = T)

df1 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/3_Manner-Result_Paper3/0_Data_AMT/10.1.13_MannerResult_Blocked_and_Interspersed/analyses_MannerResult_Blocked/rawData/2013-09-26-16-34-53_Blocked_N80a.csv", header = T)

df2 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/3_Manner-Result_Paper3/0_Data_AMT/10.1.13_MannerResult_Blocked_and_Interspersed/analyses_MannerResult_Blocked/rawData/2013-09-26-21-33-45_Blocked_N80b.csv", header = T)

df1and2AMT = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/3_Manner-Result_Paper3/0_Data_AMT/10.1.13_MannerResult_Blocked_and_Interspersed/analyses_MannerResult_Blocked/rawData/9.26.13_Batch_1278696_batch_results.csv", header = T)

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
unique(mr1.agg$SubNo)  #39


mr2.agg = aggregate(as.integer(mr2$trialNo), list(mr2$WillowSubNo), length)
colnames(mr2.agg) = c("WillowSubNo", "trialCount")
#mr2.agg$WillowSubNo = as.factor(as.character(mr2.agg$WillowSubNo))
mr2.agg$SubNo = (1 + nrow(mr1.agg)): (nrow(mr1.agg) + nrow(mr2.agg))
unique(mr2.agg$SubNo) #36
#change subject numbers in mr2 so they start at 1 greater than last sub# in mr1 and continue in ascending order until the last subject in mr2


mr1 = merge(mr1, mr1.agg)
mr2 = merge(mr2, mr2.agg)

length(colnames(mr1))
length(colnames(mr2))
colnames(mr1)    #X1380213304094
colnames(mr2)	 #X1380231245547
##need to remove these columns before combining dataFrames-- they have different names & rbind requires an exact match on #column names in order to combine 
mr1$X1380213304094 = NULL
mr2$X1380231245547 = NULL

mannerResult = rbind(mr1, mr2)
unique(mannerResult$SubNo)   #71

## start at SubNo = 72 for df3




df3 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/3_Manner-Result_Paper3/0_Data_AMT/10.8.13_MannerResult_Blocked/RawData/log/2013-10-03-13-47-26.csv", header = T)

df3AMT = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/3_Manner-Result_Paper3/0_Data_AMT/10.8.13_MannerResult_Blocked/RawData/Run1_Batch_1284637_batch_results_10.3.13.csv", header = T)

mr3 = merge(df3, df3AMT, by.x = "PayCode", by.y = "Answer.paycode")
mr3$WillowSubNo = as.factor(as.character(mr3$WillowSubNo))
mr3.agg = aggregate(as.integer(mr3$trialNo), list(mr3$WillowSubNo), length)
dim(mr3.agg)
mr3.agg[1:5, ]
colnames(mr3.agg) = c("WillowSubNo", "trialCount")
mr3.agg$WillowSubNo = as.factor(as.character(mr3.agg$WillowSubNo))

mr3.agg$SubNo = (max(mr2.agg$SubNo) +1) : (max(mr2.agg$SubNo) + nrow(mr3.agg))

unique(mr3.agg$SubNo)
mr3 = merge(mr3, mr3.agg)
mr3$X1380808089663 = NULL
mr3[1:3, ]


df4 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/3_Manner-Result_Paper3/0_Data_AMT/10.8.13_MannerResult_Blocked/RawData/log/2013-10-03-21-55-52.csv", header = T)

df4AMT = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/3_Manner-Result_Paper3/0_Data_AMT/10.8.13_MannerResult_Blocked/RawData/Run2_Batch_1285189_batch_results_10.3.13.csv", header = T)

mr4 = merge(df4, df4AMT, by.x = "PayCode", by.y = "Answer.paycode")

mr4$WillowSubNo = as.factor(as.character(mr4$WillowSubNo))
mr4.agg = aggregate(as.integer(mr4$trialNo), list(mr4$WillowSubNo), length)

mr4.agg[1:5, ]
colnames(mr4.agg) = c("WillowSubNo", "trialCount")
mr4.agg$WillowSubNo = as.factor(as.character(mr4.agg$WillowSubNo))

mr4.agg$SubNo = (max(mr3.agg$SubNo) + 1): (max(mr3.agg$SubNo) + nrow(mr4.agg))
unique(mr4.agg$SubNo)  #max = 146
mr4 = merge(mr4, mr4.agg)
mr4$X1380837363870 = NULL
mr4[1:3, ]
colnames(mr4)


df5 = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/3_Manner-Result_Paper3/0_Data_AMT/10.8.13_MannerResult_Blocked/RawData/log/2013-10-04-12-35-14.csv", header = T)

df5AMT = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/3_Manner-Result_Paper3/0_Data_AMT/10.8.13_MannerResult_Blocked/RawData/Run3_Batch_1285552_batch_results_10.4.13.csv", header = T)

mr5 = merge(df5, df5AMT, by.x = "PayCode", by.y = "Answer.paycode")

mr5$WillowSubNo = as.factor(as.character(mr5$WillowSubNo))
mr5.agg = aggregate(as.integer(mr5$trialNo), list(mr5$WillowSubNo), length)

mr5.agg[1:5, ]
colnames(mr5.agg) = c("WillowSubNo", "trialCount")
mr5.agg$WillowSubNo = as.factor(as.character(mr5.agg$WillowSubNo))

mr5.agg$SubNo = (max(mr4.agg$SubNo) + 1): (max(mr4.agg$SubNo) + nrow(mr5.agg))
unique(mr5.agg$SubNo)  #max = 147 - 185
mr5 = merge(mr5, mr5.agg)
mr5$X1380890124639 = NULL
mr5[1:3, ]
colnames(mr5)


mannerResult = rbind(mannerResult, mr3)
mannerResult = rbind(mannerResult, mr4)
mannerResult = rbind(mannerResult, mr5)
unique(mannerResult$SubNo)   #1-185

mr1.agg$SubNo  # 1-45
mr2.agg$SubNo  # 46-71
mr3.agg$SubNo	# 72-108
mr4.agg$SubNo	#109-146
mr5.agg$SubNo	#147-185

## Total 185 subjects for Manner_Result Blocked 

# setwd("~/Desktop/Dropbox/1_RESEARCH/1_Experiments/3_Manner-Result_Paper3/0_Data_AMT/10.8.13_MannerResult_Blocked/dataMod2")
setwd("~/Dropbox/1_RESEARCH/1_Experiments/3_Manner-Result_Paper3/0_Data_AMT/Paper3/dataMod")


###### START AFTER FIXING DATA ISSUES -- CODE ABOVE IS NOT ORDERED WELL ########

mannerResult$SubNo = as.factor(as.character(mannerResult$SubNo))
order(levels(mannerResult$SubNo))

mannerResult = mannerResult[order(mannerResult$SubNo, mannerResult$trialNo), ]

write.csv(mannerResult, "mannerResult_AllSub.csv")