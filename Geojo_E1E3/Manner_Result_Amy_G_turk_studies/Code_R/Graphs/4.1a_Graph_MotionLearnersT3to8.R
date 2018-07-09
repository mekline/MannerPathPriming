# Motion Verb Learners 

# useful resources:
# http://www.ats.ucla.edu/stat/r/dae/logit.htm
# http://yatani.jp/HCIstats/LinearRegression%23Rcode
# http://yatani.jp/HCIstats/LogisticRegression
# http://www.ats.ucla.edu/stat/mult_pkg/faq/general/odds_ratio.htm
##############################################  
#install.packages("packageName")
## Data sets and functions with "Analyzing Linguistic Data: A practical intro to stats (Baayen)"
library(languageR)
## For Markov-Chain Monte Carlo estimation; need for library(R)
#library(coda)
## #Groupwise computations of summary statistics, general linear contrasts etc
library(doBy)
## #Linear and Nonlinear Mixed Effects Models
library(nlme)
library(lme4)
## #Procedures for Psychological, Psychometric, and Personality
# use describe(pmdata) --> amazing!
library(psych)
require(stats)
require(ggplot2)
library(aod)
#require(GGally)
require(reshape2)
require(lme4)
require(compiler)
require(parallel)
require(boot)
library(plyr)

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

# start script (except load libraries above-- figure out which is relevant)
#detach(package:GGally)
#detach(package:reshape)

library(lme4)
library(doBy)
library(reshape2)

##############################################  
# #Experiment 3.1, Agentive, PPsentences
# setwd("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/1_BlockedAgentive_PPmotion_DOcausal/dataMod_Blocked_Agentive/")


#Experiment 3.2, INST, PPsentences
setwd("/Users/Amelie/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/dataMod_Blocked_INST")

# #Experiment 3.3, Agentive, DOsentences
# setwd("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/3_BlockedAgentive_DOframes/dataMod_Blocked_Agentive_DOsentences")

list.files()

# read in the data from Paper 3, experiment 3: agentiveMM, motion & CoS verbs in DO sentences
dat.bias.test <- read.csv("3_BiasAndTestScored.csv")

##############################################  
# reshape with bias1Acc and bias2ACC in a single column
dat.bias.test <- melt(dat.bias.test, measure.vars = c("bias1ACC", "bias2ACC"), value.name = "lexBias", variable.name = "biasQuestion") 

# stack test1ACC and test2ACC, so scores for both are in one column & column testQuestion tells you which one it came from (for logistic, so all 1/0s)
dat.bias.test <- melt(dat.bias.test, measure.vars = c("test1ACC", "test2ACC"),value.name = "testAccuracy", variable.name = "testQuestion")

##############################################      
# data for b1Motion_b2Causal from trials 1-8
t1to8.motion = dat.bias.test[dat.bias.test$trialNo < 9 & dat.bias.test$eventOrder == "b1Motion_b2Causal", ]

##############################################  
# Block 1 LexBias Data Motion (Trials 3-8)

#Compare mm vs path learners lex bias for motion verbs , trials 3-8
t3to8.motion = t1to8.motion[t1to8.motion$trialNo > 2, ]


######################################################
# Select Data
df = t3to8.motion
dependent = df$lexBias

#####################################
# To create graphs:

#collapse over trials, then over subjects [must do before running linear regression & to get descriptives by conditioncon]
df.trial = summaryBy(dependent ~ SubNo + trialNo + condition + blockOrder, Fun = c(mean), data = df)
df.sub = summaryBy(dependent.mean ~ SubNo + blockOrder, Fun = c(mean), data = df.trial)
df.sub$lexBias <- df.sub$dependent.mean.mean

#depends on whether analyzing motion or CoS data
#df.sub$condition <- ifelse(df.sub$blockOrder == "b1Means_b2Motion", "Means", "Effect")
df.sub$condition <- ifelse(df.sub$blockOrder == "b1MannerOfMotion_b2Causal", "MannerOfMotion", "Path")

df.means = summaryBy(lexBias ~ condition, Fun = c(mean), data = df.sub)
df.means$lexBias = round(df.means$lexBias.mean, 2)
df.means


########### MOTION Conditions #######################
# To isolate responses from a single condition
#whether MoMResponseVector and PathResponseVector refer to motion bias or CoS bias depends on whether df = t1to8.motion or t9to16.causal
MannerOfMotionResponseVector <- df.sub$dependent.mean.mean[df.sub$blockOrder == "b1MannerOfMotion_b2Causal"]
PathResponseVector = df.sub$dependent.mean.mean[df.sub$blockOrder == "b1Path_b2Causal"]

describe(MannerOfMotionResponseVector)
describe(PathResponseVector)

MannerOfMotion <- describe(MannerOfMotionResponseVector)
MannerOfMotion = data.frame(c(MannerOfMotion[3], MannerOfMotion[13]))
MannerOfMotion$condition = "MannerOfMotion"

Path <- describe(PathResponseVector)
Path <- data.frame(c(Path[3], Path[13]))
Path$condition = "Path"

B1Motion = rbind(MannerOfMotion, Path)

B1Motion$Mean <- round(B1Motion$mean, 2)
B1Motion$SE <- round(B1Motion$se, 2)



# ggplot(data = df.means, aes(x=condition, y= lexBias*100, fill= condition,)) + geom_bar(aes(fill= condition), width = .7, stat = "identity") + ylim(0, 100) + guides(fill = FALSE) + xlab("Verb learning condition") + ylab("Percent of Manner-of-Motion conjectures") + ggtitle("Lexicalization Bias for Motion Events (Trials 3-8)") + theme_bw()



# ggplot(data = df.means, aes(x=condition, y= lexBias*100, fill= condition,)) + geom_bar(aes(fill= condition), width = .7, stat = "identity") + ylim(0, 100) + guides(fill = FALSE) + xlab("Verb learning condition") + ylab("Percent of Manner-of-Motion conjectures") + ggtitle("MM vs Path learners: Bias for Motion Verbs (Trials 3-8)") + theme_bw()


# ggplot(data = B1Motion, aes(x=condition, y= mean*100, fill= condition,)) +
	# geom_errorbar(aes(ymin=mean*100-se*100, ymax=mean*100+se*100), width=.1) + 
	# geom_bar(aes(fill= condition), width = .7, stat = "identity") + 
	# ylim(0, 100) + 
	# guides(fill = FALSE) + 
	# xlab("\nPart 1: Verb learning condition") + 
	# ylab("Percent of Manner-of-Motion conjectures") + 
	# ggtitle("Experiment 3: MM vs Path learners \nBias for Motion Verbs (Trials 3-8)") + 
	# theme_bw()


# MM vs Path learners for motion verbs : trials 3-8
ggplot(data = B1Motion, aes(x=condition, y= mean*100, fill= condition,)) +
	geom_errorbar(aes(ymin=mean*100-se*100, ymax=mean*100+se*100), width=.1) + 
	geom_bar(aes(fill= condition), width = .7, stat = "identity") + 
	ylim(0, 100) + 
	guides(fill = FALSE) + 
	xlab("\nVerb learning condition") + 
	ylab("\nPercent of Manner-of-Motion conjectures") + 
	ggtitle("MM vs Path \nBias for Motion Verbs (T3-8)") + 
	theme_bw()



