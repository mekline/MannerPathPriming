# ## TO set depending upon particular data set
# #directory to set: 

# # Paper 3, expt 3.1 - Agentive  
# directory = "~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/1_BlockedAgentive_PPmotion_DOcausal/dataMod_Blocked_Agentive"

# inputCSV = "~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/1_BlockedAgentive_PPmotion_DOcausal/dataMod_Blocked_Agentive/0_mannerResult_AllSub.csv"

# outputCSV = "1_mannerResult_Blocked_Agentive_AllSub_CritApplied_5.31.14.csv"

#Paper 3, expt 3.2 -INST mm
directory = "~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/dataMod_Blocked_INST"

inputCSV = "1_mannerResult_Blocked_INST_AllSub_.csv"

outputCSV = "2_mannerResult_Blocked_INST_AllSub_CritApplied.csv"

# Paper 3, expt 3.3 - Agentive, DO sentences
# directory = "~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/3_BlockedAgentive_DOframes/dataMod_Blocked_Agentive_DOsentences"

# # #initial csvFile to read in
# inputCSV = "1_mannerResult_AllSub.csv"

# # #final csv file to write
# outputCSV = "2_mannerResult_Blocked_Agentive_DOsentences_AllSub_CritApplied.csv"

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


### ***exclude subjects whose first language is not English or who are not from USA  [not actually necessary to check country b/ restrict to participants in USA***]
# mannerResult$DemographicsCrit = ifelse(mannerResult$Answer.English == "yes" & mannerResult$Answer.country == "USA", 1, 0)

setwd(directory)
list.files()

mannerResult = read.csv(inputCSV, header = T)

mannerResult$SubjectNumberAfterPayCodeMergesAMTandWillowData = length(unique(mannerResult$SubNo))

mannerResult$DemographicsCrit = ifelse(mannerResult$Answer.English == "yes", 1, 0)

mannerResult$subExcl_NotUSA_notEngl = length(unique(mannerResult$SubNo[mannerResult$DemographicsCrit == 0]))  

mannerResult = mannerResult[mannerResult$DemographicsCrit == 1,]

#mannerResult[1:3, c(1:3, 76:79)]        #8 excluded (176 post merge w amt; 168 post demoCrit subjects)
length(unique(mannerResult$SubNo))
#unique(mannerResult$trialNo)


length(unique(mannerResult$SubNo[mannerResult$blockOrder == "b1MannerOfMotion_b2Causal"]))  #
length(unique(mannerResult$SubNo[mannerResult$blockOrder == "b1Path_b2Causal"]))    #
length(unique(mannerResult$SubNo[mannerResult$blockOrder == "b1Means_b2Motion"]))   #
length(unique(mannerResult$SubNo[mannerResult$blockOrder == "b1Effect_b2Motion"]))	#


##########################
mannerResult$block1 = 0
mannerResult$block1[mannerResult$trialNo %in% c(1, 2, 3, 4, 5, 6, 7, 8)] = 1

mannerResult$block2 = 0
mannerResult$block2[mannerResult$trialNo %in% c(9, 10, 11, 12, 13, 14, 15, 16)] = 1

#### note only ambig and bias sections apply for T9-16 --> so diff exclusionary crit for trials:
### ***exclude subjects that didn't see enough videos c trials as well as trials for subjects that only failed to see videos on less than 2 trials
mannerResult$seeAmbig = ifelse(mannerResult$seeAmbigV1 == 0 & mannerResult$seeAmbigV2 == 0, 0, 1)

mannerResult$seeBias1 = ifelse(mannerResult$bias1RESP == -1, 0, 1)
mannerResult$seeBias2 = ifelse(mannerResult$bias2RESP == -1, 0, 1)

mannerResult$seeTrain1 = ifelse(mannerResult$seeTrain1a == 0 & mannerResult$seeTrain1b == 0, 0, 1)
mannerResult$seeTrain2 = ifelse(mannerResult$seeTrain2a == 0 & mannerResult$seeTrain2b == 0, 0, 1)
mannerResult$seeTrain3 = ifelse(mannerResult$seeTrain3a == 0 & mannerResult$seeTrain3b == 0, 0, 1)

mannerResult$seeTest1 = ifelse(mannerResult$test1RESP == -1, 0, 1)
mannerResult$seeTest2 = ifelse(mannerResult$test2RESP == -1, 0, 1)

mr1 = mannerResult[mannerResult$block1 == 1, ]
mr2 = mannerResult[mannerResult$block2 == 1, ]

mannerResult$SubNo = as.factor(as.character(mannerResult$SubNo))
NumSubjectsBeforeVidCheck = length(unique(mannerResult$SubNo))

NumTrialsBeforeVidCheck = nrow(mannerResult)
#length(mannerResult) --> gives number of columns

### WRONG
# mannerResult$seeBias1 = ifelse(mannerResult$seeBiasV1 == 0 & mannerResult$bias1RESP == -1, 0, 1)
# mannerResult$seeBias2 = ifelse(mannerResult$seeBiasV2 == 0 & mannerResult$bias2RESP == -1, 0, 1)
# # mannerResult$seeBias = ifelse(mannerResult$seeBiasV1 == 0 & mannerResult$seeBiasV2 == 0, 0, 1)
# mannerResult$seeTest1 = ifelse(mannerResult$seeTestV1 == 0 & mannerResult$test1RESP == -1, 0, 1)
# mannerResult$seeTest2 = ifelse(mannerResult$seeTestV2 == 0 & mannerResult$test2RESP == -1, 0, 1)

#if see at least one of each of eight unique videos in a single trial, seeVidCheck is scored 1 and trial can be included; if neither are seen, trial is excluded due to 'video loss'
mr1$seeVidCheck = ifelse(mr1$seeAmbig == 0 | mr1$seeBias1 == 0 | mr1$seeBias2 == 0| mr1$seeTrain1 == 0 | mr1$seeTrain2 == 0 | mr1$seeTrain3 == 0 | mr1$seeTest1 == 0 | mr1$seeTest2 == 0, 0, 1)

# get proportion of trials 'lost' (that will be excluded) because at least 1 of 2 presentations of each unique video was not seen
mr1$ProportionOfVideoLostTrials = round(sum(mr1$seeVidCheck == 0)/length(mr1$seeVidCheck), 2)

#get number of trials lost due to video loss; a trial is included if at least one presentation of the ambig and training videos is seen and the 2nd presentation of the bias and test videos is seen (videos are 'lost' even if the first presentation of the bias and test videos is seen-- the second presentation is the one to which they provide yes/no judgements about verb extension and therefore must be seen --if unseen, response score is '-1')
mr1$NumberOfVideoLostTrials = sum(mr1$seeVidCheck == 0)    ## was wrong b/c mis-wrote variable as seeVideoCheck; correct: seeVidCheck

# PART 2: now do the same for data from all subjects from PART 2 of the experiment; novel verb extension only
mr2$seeVidCheck = ifelse(mr2$seeAmbig == 0 | mr2$seeBias1 == 0 | mr2$seeBias2 == 0, 0, 1)
mr2$ProportionOfVideoLostTrials = round(sum(mr2$seeVidCheck == 0)/length(mr2$seeVidCheck), 2)
#0.06
mr2$NumberOfVideoLostTrials = sum(mr2$seeVidCheck == 0)

mannerResult = rbind(mr1, mr2)

# mannerResult included subjects -- pass demographics crit, trial # crit & seeVid Crit
# also exclude trials where seeVidCrit is not met
0 %in% mannerResult$DemographicsCrit
0 %in% mannerResult$seeVidCheck

# these should return 'True' because we haven't excluded invalid (vid loss) trials yet
-1 %in% mannerResult$bias1RESP
-1 %in% mannerResult$bias2RESP

-1 %in% mannerResult$test1RESP
-1 %in% mannerResult$test2RESP

-1 %in% mannerResult$bias1RESP
-1 %in% mannerResult$bias2RESP


# total number of trials before trials are removed b/c subject didn't see enough videos in a single trial:
#mannerResult$NumTrialsBeforeSeeVidCheckCrit = nrow(mannerResult)

mannerResult2 = mannerResult[mannerResult$DemographicsCrit == 1 & mannerResult$seeVidCheck == 1,]

############################################################################
length(unique(mannerResult2$SubNo))     # N after democrit and seevidcheck

0 %in% mannerResult2$DemographicsCrit
0 %in% mannerResult2$seeVidCheck

### should return False, b/c invalid, video loss trials are removed from mannerResult2. 
-1 %in% mannerResult2$bias1RESP
-1 %in% mannerResult2$bias2RESP

-1 %in% mannerResult2$test1RESP
-1 %in% mannerResult2$test2RESP

-1 %in% mannerResult2$bias1RESP
-1 %in% mannerResult2$bias2RESP
#################################################################
library(plyr)
mr1 = mannerResult2[mannerResult2$block1 == 1, ]   #trials 1-8
mr2 = mannerResult2[mannerResult2$block2 == 1, ]	#trials 9-16; mr2 has NAs for test1RESP and test2RESP-no VLtest

# part 1 of experiment: responses for lex bias and verb learning test # not actually necessary b/c all seeVid trials marked 0 (and those with -1 get 0) were removed when created mannerResult2 from manenrResult1
mr1 = mr1[mr1$bias1RESP != -1 & mr1$bias2RESP != -1, ]
mr1 = mr1[mr1$test1RESP != -1 & mr1$test2RESP != -1, ]
# part 2 of experiment: lex bias extension only
mr2 = mr2[mr2$bias1RESP != -1 & mr2$bias2RESP != -1, ]

mr1$trialNo = as.factor(as.character(mr1$trialNo))
mr2$trialNo = as.factor(as.character(mr2$trialNo))

mr1.agg = aggregate(as.integer(mr1$trialNo), list(mr1$SubNo), length)
colnames(mr1.agg) = c("SubNo", "trialCountBlock")
mr1.agg$meetMinTrialCrit = ifelse(mr1.agg$trialCountBlock >= 6, 1, 0)
mr1.agg2 = mr1.agg[mr1.agg$meetMinTrialCrit == 1, ]

m1 = join(mr1, mr1.agg2, by = "SubNo", type = "inner")

# excluding subjects that fail to meet min trial count for part 1 (invalid subject if fail to have 6/8 in either section)
# then check if the remaining subject's saw a sufficient number of videos in part 2; only retain the ones that do 
#paired subset of data of mr2 that inludes only the rows with values of the ids found in mr1$SubNo
#selectedSubjects1 = as.character(m2$SubNo) %in% as.character(m1$SubNo)
#m2 = m2[selectedSubjects1, ]

## same for T9-16 (bias only trials - verb extension)
mr2.agg = aggregate(as.integer(mr2$trialNo), list(mr2$SubNo), length)
colnames(mr2.agg) = c("SubNo", "trialCountBlock")
mr2.agg$meetMinTrialCrit = ifelse(mr2.agg$trialCountBlock >= 6, 1, 0)

mr2.agg2 = mr2.agg[mr2.agg$meetMinTrialCrit == 1,]
m2 = join(mr2, mr2.agg2, by = "SubNo", type = "inner")

# mr1 and mr2 are data sets for part 1 and 2, respectively; these are half of the full data set each (not just agg w/ sub vals as above)
#paired subset of data of mr2 that inludes only the rows with values of the ids found in mr1$SubNo
selectedSubjects1 = as.character(m2$SubNo) %in% as.character(m1$SubNo)
m2 = m2[selectedSubjects1, ]     #returns T/F 

# paired subset of data of mr1 that includes only the rows w/ values of if the ids that are in mr1 
# only retain subjects if they are also in mr1
selectedSubjects2 = as.character(m1$SubNo) %in% as.character(m2$SubNo)
m1 = m1[selectedSubjects2, ]


#wmake sure equal number of subjects so m1 and m2 can be joined. 
length(unique(m1$SubNo)) == length(unique(m2$SubNo))

#join partial data sets; m1 for trials 1-8 and m2 for trials 9-16; 
#has only included subjects (and only included trials for those subjects)
mannerResultFinal = rbind(m1, m2)

# NumberValidTrialsIncludedSubjectsVariable
# NumTrialsBeforeVidCheck

# compute number of subjects lost to invalid trials: subtract # of subjects in mannerResultFinal from # of subjects in mannerResult (stored in variable: NumSubjectsBeforeVidCheck)--which was before subjects were removed b/c didnt have sufficient number of trials); [NOTE: NumberInvalidSubjects does not include number lost b/c not English speakers]
mannerResultFinal$SubNo = as.factor(as.character(mannerResultFinal$SubNo))
NumberValidSubjects = length(unique(mannerResultFinal$SubNo))   #
mannerResultFinal$SubExcl_FailMinTrialCrit = NumSubjectsBeforeVidCheck - NumberValidSubjects

#compute # of trials lost b/c of videoloss; subtract number of trials remaining after seeVidCheck and minimum trial criterion are applied (= nrow(mannerResultFinal) from the number of trials BEFORE the seeVid crit was applied (stored in Variable: NumTrialsBeforeVidCheck)   and after seeVidCheck was computed and trials not meeting minTrialCrit of >6 trials/part were cut; 
#valid trials are only those that are valid b/c meet see vid and b/c subject has min number of trials
mannerResultFinal$NumberValidTrialsTotal = nrow(mannerResultFinal) 
mannerResultFinal$NumberInvalidTrialsTotal = abs(nrow(mannerResultFinal) - NumTrialsBeforeVidCheck) 

mannerResultFinal$ProportionInvalidTrialsTotal = mannerResultFinal$NumberInvalidTrialsTotal/NumTrialsBeforeVidCheck

# Find number of valid trials/included subject (look in dataset MannerResultFinal)
mannerResultFinal.agg = aggregate(as.integer(mannerResultFinal$trialNo), list(mannerResultFinal$SubNo), length)
colnames(mannerResultFinal.agg) = c("SubNo", "NumberOfTrialsPerIncludedSubject")

# compute average valid trials per included subject; if close to 16, means that *most* of the invalid trials came from excluded subjects-- server issues likely cause!! 
mannerResultFinal.agg$AvgNumberValidTrialsPerIncludedSubject = sum(mannerResultFinal.agg$NumberOfTrialsPerIncludedSubject)/nrow(mannerResultFinal.agg)

# total number of included trials (get by adding total # of trials for each participant); variable = NumberOfTrialsPerIncludedSubject)
SumValidTrialsForValidSubjects = sum(mannerResultFinal.agg$NumberOfTrialsPerIncludedSubject) 
#SumValidTrialsForValidSubjects
# Proportion of lost trials -- considering only included subjects (if each included subject had all 16 trials (length(unique(mannerResultFinal$trialNo))), total number of subjects = nrow(mannerResultFinal.agg); 
#then compute total possible trials = 16*nrow(mannerResultFinal.agg)

# number of trials if each subject had all 16 trials (nrow for mannerResultFinal.agg gives total N of subjects):
PossibleTrialsTotalInclSubOnly = (length(unique(mannerResultFinal$trialNo))*nrow(mannerResultFinal.agg))
#PossibleTrialsTotalInclSubOnly

# proportion of lost trials- considering only included subjects
mannerResultFinal.agg$ProportionInvalidTrialsIncludedSubjectsOnly = 1 - SumValidTrialsForValidSubjects/PossibleTrialsTotalInclSubOnly

#mannerResultFinal.agg[1:3, ]
#length(unique(mannerResultFinal$trialNo))

#rejoin per subject data with full data set containing data for included participants only
mannerResultFinal = join(mannerResultFinal, mannerResultFinal.agg, by = "SubNo", type = "inner")

0 %in% mannerResultFinal$meetMinTrialCount

-1 %in% mannerResultFinal$bias1RESP
-1 %in% mannerResultFinal$bias2RESP
-1 %in% mannerResultFinal$test1RESP
-1 %in% mannerResultFinal$test2RESP

mannerResultFinal$NumberIncludedSubjects = length(unique(mannerResultFinal$SubNo))

mannerResultFinal$MannerOfMotionIncludedSubjectTotal = length(unique(mannerResultFinal$SubNo[mannerResultFinal$blockOrder == "b1MannerOfMotion_b2Causal"]))  
mannerResultFinal$PathIncludedSubjectTotal = length(unique(mannerResultFinal$SubNo[mannerResultFinal$blockOrder == "b1Path_b2Causal"]))    
mannerResultFinal$MeansIncludedSubjectTotal = length(unique(mannerResultFinal$SubNo[mannerResultFinal$blockOrder == "b1Means_b2Motion"]))   
mannerResultFinal$EffectIncludedSubjectTotal = length(unique(mannerResultFinal$SubNo[mannerResultFinal$blockOrder == "b1Effect_b2Motion"]))	

mannerResultFinal[1:3, ]

write.csv(mannerResultFinal, outputCSV)



##############################################

length(unique(mannerResultFinal$SubNo[mannerResultFinal$blockOrder == "b1MannerOfMotion_b2Causal"]))  #51 --> 32
length(unique(mannerResultFinal$SubNo[mannerResultFinal$blockOrder == "b1Path_b2Causal"]))    #43 --> 35
length(unique(mannerResultFinal$SubNo[mannerResultFinal$blockOrder == "b1Means_b2Motion"]))   #39 --> 30
length(unique(mannerResultFinal$SubNo[mannerResultFinal$blockOrder == "b1Effect_b2Motion"]))	#31 --> 23

################################3

# # Inclusionary Criteria:
# mannerResult$DemographicsCrit == 1
# # 8 subjects lost 

# mannerResult$meetMinTrialCrit == 1
# # 26 subjects lost

# mannerResult$seeVidCheck == 1
# 1 subject lost

#######################

#inputFile for 3.1 (agentive MM, motion in PP frames)

#inputFile for 3.2 (INST MM, motion in PP frames)

#inputFile for 3.3 (agentive MM, motion in DO frames)


#inputFile = "~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/BlockedAgentive/dataMod_Blocked_Agentive_DOsentences/2_mannerResult_Blocked_Agentive_DOsentences_AllSub_CritApplied.csv"
#df = read.csv(inputFile, header = T)

#df = read.csv("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/1_BlockedAgentive_PPmotion_DOcausal/dataMod_Blocked_Agentive/1_mannerResult_Blocked_Agentive_AllSub_CritApplied", header = T)

########################################################################################################
df <- mannerResultFinal

#compute bias and test Accuracy
df$bias1ACC = ifelse(df$bias1RESP == df$biasV1Ans, 1, 0)
df$bias2ACC = ifelse(df$bias2RESP == df$biasV2Ans, 1, 0)
df$biasACC = (df$bias1ACC + df$bias2ACC)/2

df$test1ACC = ifelse(df$test1RESP == df$testV1Ans, 1, 0)
df$test2ACC = ifelse(df$test2RESP == df$testV2Ans, 1, 0)
df$testACC = (df$test1ACC + df$test2ACC)/2

write.csv(df, "3_BiasAndTestScored.csv")
######################################################################################################

df$SubNo = as.factor(as.character(df$SubNo))
length(unique(df$SubNo))
unique(df$blockOrder)

length(unique(df$SubNo[df$blockOrder == "b1MannerOfMotion_b2Causal"])) #
length(unique(df$SubNo[df$blockOrder == "b1Path_b2Causal"])) #
length(unique(df$SubNo[df$blockOrder == "b1Means_b2Motion"])) #
length(unique(df$SubNo[df$blockOrder == "b1Effect_b2Motion"])) #

