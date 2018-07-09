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
setwd("~/Dropbox/1_RESEARCH/1_Experiments/1_Thesis_Research/3_Paper3_Manner-Result/Paper3_AMT_Data/2_BlockedINST/dataMod_Blocked_INST")

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

#data for b1Causal_b2Motion
t1to8.causal = dat.bias.test[dat.bias.test$trialNo < 9 & dat.bias.test$eventOrder == "b1Causal_b2Motion", ]

##############################################  
#Motion lexicalization bias Block 1; compare mm vs path learners manner preference scoress (lex bias scored as manner bias)
#bias on trial 1
t1.motion = t1to8.motion[t1to8.motion$trialNo == 1, ]
df.sub = summaryBy(lexBias ~ SubNo + blockOrder, Fun = c(mean), data = t1.motion)
mmT1 = summary(df.sub$lexBias.mean[df.sub$blockOrder == "b1MannerOfMotion_b2Causal"])
pathT1 = summary(df.sub$lexBias.mean[df.sub$blockOrder == "b1Path_b2Causal"])
motionVerbT1 = mean(df.sub$lexBias.mean)
mmT1
pathT1
motionVerbT1
#CoS lexicalization bias Block 1; compare means vs effect learners manner preference scoress (lex bias scored as manner bias)
#bias on trial 1
t1.causal = t1to8.causal[t1to8.causal$trialNo == 1, ]
df.sub = summaryBy(lexBias ~ SubNo + blockOrder, Fun = c(mean), data = t1.causal)
meanT1 = summary(df.sub$lexBias.mean[df.sub$blockOrder == "b1Means_b2Motion"])
effectT1 = summary(df.sub$lexBias.mean[df.sub$blockOrder == "b1Effect_b2Motion"])
CoSVerbT1 = mean(df.sub$lexBias.mean)
meanT1
effectT1
CoSVerbT1
##############################################  
# Block 1 LexBias Data

#Compare mm vs path learners lex bias for motion verbs , trials 3-8
t3to8.motion = t1to8.motion[t1to8.motion$trialNo > 2, ]

#Compare means vs effect learners lex bias for CoS verbs, trials 3-8 
t3to8.causal = t1to8.causal[t1to8.causal$trialNo > 2, ]

##############################################  
#Block 2: Data for Lex bias

#b1Motion_b2Causal -- use to see if lex bias for CoS verbs differs if learned mm vs path verbs in b1
t9to16.causal = dat.bias.test[dat.bias.test$trialNo > 8 & dat.bias.test$eventOrder == "b1Motion_b2Causal",]

#b1Causal_b2Motion -- use to see if lex bias for motion verbs differs if learned means vs effect verbs in b1
t9to16.motion = dat.bias.test[dat.bias.test$trialNo > 8 & dat.bias.test$eventOrder == "b1Causal_b2Motion",]

# first half vs 2nd half analyses: t9-12 vs t12-16
# CoS verb extension data from motion verb learners
t9to12.causal = t9to16.causal[t9to16.causal$trialNo <= 12, ]
t13to16.causal = t9to16.causal[t9to16.causal$trialNo > 12, ]

# Motion verb extension data from CoS verb learners
t9to12.motion = t9to16.motion[t9to16.motion$trialNo <= 12, ] 
t13to16.motion = t13to16.causal[t13to16.causal$trialNo > 12, ]

##############################################

#select data from above section to analyze
#options for lex bias: 
#for Block 1:t3to8.motion, t3to8.causal  [lexBias; where .motion and .causal refer to verb learning condition]
#for Block 2: t9to16.motion, t9to16.causal [lexBias; where .motion and .causal refer to type of event seen during block 2, i.e. t9to16.motion means b1 learners mm or path verbs, now assessing bias for b2 CoS events]
######### Block 2 also split into first and 2nd half to see if effect of bias across semantic fields is very short lived (only evident during the first 4 trials or persists across all 8 trials: t9to12.causal and t3to15.causal contain CoS bias data from motion verb learners;   ) 
df = t9to16.motion
dependent = df$lexBias

#options for test accuracy (relevant for block 1 only): t1to8.motion, t1to8.causal; [.motion and .causal refer to verb learning condition]

df = t1to8.motion
dependent = df$testAccuracy

##############################################

#collapse over trials, then over subjects [must do before running linear regression & to get descriptives by conditioncon]
df.trial = summaryBy(dependent ~ SubNo + trialNo + blockOrder, Fun = c(mean), data = df)
df.sub = summaryBy(dependent.mean ~ SubNo + blockOrder, Fun = c(mean), data = df.trial)

# To isolate responses from a single condition
#whether MoMResponseVector and PathResponseVector refer to motion bias or CoS bias depends on whether df = t1to8.motion or t9to16.causal
MannerOfMotionResponseVector <- df.sub$dependent.mean.mean[df.sub$blockOrder == "b1MannerOfMotion_b2Causal"]
PathResponseVector = df.sub$dependent.mean.mean[df.sub$blockOrder == "b1Path_b2Causal"]

# vectors below refer to CoS bias for trials t1to8.causal and to motion bias for trials t9to16.motion
MeansResponseVector = df.sub$dependent.mean.mean[df.sub$blockOrder == "b1Means_b2Motion"]
EffectResponseVector = df.sub$dependent.mean.mean[df.sub$blockOrder == "b1Effect_b2Motion"]

describe(MannerOfMotionResponseVector)
describe(PathResponseVector)
describe(MeansResponseVector)
describe(EffectResponseVector)

# One-sample t-test to determine if lexBias for single condition differs from chance (baseline MANNER preference: manner-of-motion bias or means bias)
t.test(MannerOfMotionResponseVector, mu = motionVerbT1, alternative = "greater")
t.test(PathResponseVector, mu = motionVerbT1, alternative = "less")

t.test(MeansResponseVector, mu = CoSVerbT1, alternative = "greater")
t.test(EffectResponseVector, mu = CoSVerbT1, alternative = "less")

# one-sample t-test: is lex bias or VL test for single condition diff from chance, here defined as 0.5
t.test(MannerOfMotionResponseVector, mu = 0.5) #, alternative = "greater")
t.test(PathResponseVector, mu = 0.5) #, alternative = "less")

t.test(MeansResponseVector, mu = 0.5)
t.test(EffectResponseVector, mu = 0.5)


########Following regressions and Wilcox test the effect of Condition-- do responses of participants in one learning condition differ from those in the corresponding other (manner-of-motion vs. path; means vs. effect)
##############################################
# Univariate Linear Regression: 
#df.lm = lm(dependent.mean.mean ~ blockOrder, data = df.sub)
#summary(df.lm)

##############################################
#same as describe(MannerOfMotionResponseVector) etc above
# describe(df.sub$dependent.mean.mean[df.sub$blockOrder == "b1MannerOfMotion_b2Causal"])
# describe(df.sub$dependent.mean.mean[df.sub$blockOrder == "b1Path_b2Causal"])

# describe(df.sub$dependent.mean.mean[df.sub$blockOrder == "b1Means_b2Motion"])
# describe(df.sub$dependent.mean.mean[df.sub$blockOrder == "b1Effect_b2Motion"])
##############################################

#  WILCOX TEST: Does response differ across conditions (MM vs path; Means vs Effect)?
#Wilcox test or bias (t3-8) or bias (t9-16) scores for manner and result conditions 
#example for testing bias during verb learning t3-8, when learning mm and path verbs OR t9-16 for block 2 for CoS verbs, when in b1 learned motion verbs
#manner = df.sub[df.sub$blockOrder == "b1MannerOfMotion_b2Causal", ]$dependent.mean
#result = df.sub[df.sub$blockOrder == "b1Path_b2Causal", ]$dependent.mean
#wilcox.test(manner, result, alternative="two.sided", exact=F)

# manner = df.sub[df.sub$blockOrder == "b1MannerOfMotion_b2Causal", ]$dependent.mean.mean
# result = df.sub[df.sub$blockOrder == "b1Path_b2Causal", ]$dependent.mean.mean

# manner = df.sub[df.sub$blockOrder == "b1Means_b2Motion", ]$dependent.mean.mean
# result = df.sub[df.sub$blockOrder == "b1Effect_b2Motion", ]$dependent.mean.mean

# Same as manner/result computed above
manner = MannerOfMotionResponseVector
result = PathResponseVector

manner = MeansResponseVector
result = EffectResponseVector

# wilcoxon rank sum test (same as Mann-Whitney U; compare two samples to see if they differ)
wilcox.test(manner, result, alternative="two.sided", exact=F)
# same as above; 2-sample wilcoxon rank sum test (Mann-Whitney U)
#wilcox.test(df.sub$dependent.mean.mean ~ df.sub$blockOrder, exact = F)

# Wilcoxon one-sample signed rank test ()equivalent to a one-sample t-test): V statistic
# wilcox.test (x, alternative = (c("two-sided", "greater", "less"), exact = F, paired = F))

## Lex Bias 3-8: Wilcoxon V
# on trials 3-8, is manner preference greater/less than BASELINE preference in manner and result condition, respectively
# mu = baseline preference for manner or result verbs
#mu = motionVerbT1  
#mu = CoSVerbT1
wilcox.test(MannerOfMotionResponseVector, alternative = "greater", mu = motionVerbT1, exact = F)
wilcox.test(PathResponseVector, alternative = "less", mu = motionVerbT1, exact = F)

wilcox.test(MeansResponseVector, alternative = "greater", mu = CoSVerbT1, exact = F)
wilcox.test(EffectResponseVector, alternative = "less", mu = CoSVerbT1, exact = F)

#Lex bias 3-8 OR Lex bias 9-16: Wilcoxon V
# On trials 3-8 or trials 9-16, is manner preference greater than CHANCE in manner condition and less than chance in the result condition? 
#(reliable manner and result preferences?); mu = chance, 0.5
wilcox.test(manner, alternative = "greater", mu = 0.5, exact = F)
wilcox.test(result, alternative = "less", mu = 0.5, exact = F)

## Verb Learning: Wilcoxon V
# on trials 1-8 is performance (accuracy) on verb learning test greater than CHANCE for manner and result conditions, respectively??
wilcox.test(manner, alternative = "two.sided", mu = 0.5, exact = F)
wilcox.test(result, alternative = "two.sided", mu = 0.5, exact = F)

##############################################
#mannerMean = mean(df.sub$blockOrder == "b1MannerOfMotion_b2Causal")
#resultMean = mean(df.sub$blockOrder == "b1Path_b2Causal")
#manner2 = df.sub[df.sub$blockOrder == "b1MannerOfMotion_b2Causal", ]$dependent.mean.mean
#manner == manner2     --> TRUE for each number of vector

##############################################
# Logistic Regressions

# CoS verb lex bias (b1 motion verbs)
#log regression w/o any predictors
#df_reduced.log = glm(dependent ~ 1, data = df, family = "binomial")
#summary(df_reduced.log)

#log regression with only fixed effect
#df.log = glm(dependent ~ 1 + blockOrder, data = df, family = "binomial")
#summary(df.log)

##### can't use the code below b/c binomial glm requires 0/1 data and subject scores are btw 0 & 1; 
##### but the 2 log regressions above may also be wrong b/c there are too many degrees of freedom [doesn't auto-detect groups like mixed-effects models]
#### df.log = glm(dependent.mean.mean ~ 1 + blockOrder, data = df.sub, family = "binomial")
#### summary(df.log)

##############################################
#log regression with fixed and subjects and items as random effects
df_si.log = glmer(dependent ~ 1 + blockOrder + (1 | SubNo) + (1 | itemId), data = df, family = "binomial")
summary(df_si.log)

##############################################
# first half vs 2nd half of cross-field verb extension trials: 9-12 vs 13-16:
#df.9to12 = df[df$trialNo <= 12, ]
#unique(df.9to12$trialNo)
# score 0 if trials 9-12 and 1 if trials 13-16
df$trialsplit = ifelse(df$trialNo > '12', 1, 0)
df_si.split.log = glmer(dependent ~ 1 + blockOrder + trialsplit + blockOrder*trialsplit + (1 | SubNo) + (1 | itemId), data = df, family = "binomial")
summary(df_si.split.log)
##############################################




##############################################
# log model with subjects and items as random effects w/ slopes freely varying
df_si.slopes.log = glmer(dependent ~ 1 + blockOrder + (1 + blockOrder | SubNo) + (1 + blockOrder | itemId), data = df, family = "binomial")
summary(df_si.slopes.log)
##############################################

# compare models with subject and items as random effects; only model 2 allows slopes of random effects to vary
anova(df_si.log, df_si.slopes.log, test = "Chisq")


### to get 95% confidence interval; below is for model w/o varied slopes
sum.coef <- summary(df_si.log)$coef         #just retrieve coefficients from model
est<-exp(sum.coef[,1])  #  return the estimates (the betas) but as odds instead of log-odds [get odds ratios by exponentiating]
upper.ci<-exp(sum.coef[,1]+1.96*sum.coef[,2]) #gives upper bound 95% CI (as odds, note exponentiation)
lower.ci<-exp(sum.coef[,1]-1.96*sum.coef[,2]) # lower bound for 95% CI  (as odds)
est
log(upper.ci)
log(lower.ci)

#get confidence intervals using profiled log-likelihood
confint(df_si.log) 

#returns model's log likelihood; note this is also found in summary (but w/o df)
logLik(df_si.log)  

#NOT SURE EITHER OF THE FUNCTIONS BELOW ARE CORRECT:
# to compute how the odds of selecting a manner meaning (eg. choosing manner-match vid) changes as a function of learning condition
#exp(est[2])
#To transform the results to probabilities type:
#exp(est[2])/(1+exp(est[2])) 


##################################
#difference in deviance for the 2 models (e.g., the test statistic) (here, model w/ and model w/o predictors)
with(df_si.log, null.deviance - deviance)
# the degrees of freedom for the difference between the two models is equal to the number of predictor variables in the mode, and can be obtained using:
with(mylogit, df.null - df.residual)
#Finally, the p-value can be obtained using:
with(mylogit, pchisq(null.deviance - deviance, df.null - df.residual, lower.tail = FALSE))
## p-value lets you see if the model w pred is better than the null; called likelihood ratio test; 
#the deviance residual is -2*log likelihood)

#df_si.log #returns description of model (unlike summary, does not include z or pvalues)
#anova(df_si.log, test = "Chisq") #get ANOVA version of regression
#coef(df_si.log)     #get intercept and slope for each subject and item
#coef(df_si.slopes.log) #as above but slopes will vary - cf. models
##############################################
#log regression with fixed & random subjects only
df_s.log = glmer(dependent ~ 1 + blockOrder + (1 | SubNo), data = df, family = "binomial")
summary(df_s.log)

#log regression with fixed and random items
df_i.log = glmer(dependent ~ 1 + blockOrder + (1 | itemId), data = df, family = "binomial")
summary(df_i.log)

#comparing models
#anova(df_reduced.log, df.log, test = "Chisq")  #model with intercept only vs with predictor (no random effects in either model)
#anova(df.log, df_si.log, test = "Chisq")       #model without random effects vs. with sub & item random effects
anova(df_si.log, df_s.log, test = "Chisq")     #model with random sub & items vs sub only
anova(df_si.log, df_i.log, test = "Chisq")     #model with random sub & items vs items only

##############################################

# to compute how the odds of selecting a manner meaning (eg. choosing manner-match vid) changes as a function of learning condition
exp(coef(df_si.log)) 
exp(est[2])

# to create 95% confidence interval for the estimate
exp(confint.default(df_si.log))


To transform the results to probabilities type: 

  > exp(ci)/(1+exp(ci)) 
[1] 0.1145063 0.7198689 
##############################################


########### GLM models ###############
## Below GLMs for dependent variable of choice (b1 test acc, b1 bias, b2 bias)
# GLM with no predictors
#df.reduced = lmer(dependent ~ 1, data = df)                                     

# GLM with subjects and items as random effects; no slopes
df.si.glm = lmer(dependent ~ 1 + blockOrder + (blockOrder | SubNo) + (blockOrder | itemId), data = df)                                 
summary(df.si.glm)

# GLM with subjects only as random effect
df.s.glm = lmer(dependent ~ 1 + blockOrder + (blockOrder | SubNo), data = df)
summary(df.s.glm)

# GLM with items only as random effect                                 
df.i.glm = lmer(dependent ~ 1 + blockOrder + (blockOrder | itemId), data = df)                                
summary(df.i.glm)

# comparing models no predictors with 1; 1 with 2; 1 with 3
#anova(df.reduced, df.si.glm, test = "Chisq")                                 
anova(df.si.glm, df.s.glm, test = "Chisq")                                 
anova(df.si.glm, df.i.glm)


# GLM with subjects and items, both with random slopes for block 2 CoS bias (learned motion verbs b1)                             
df.si.slopes.glm = lmer(dependent ~ 1 + blockOrder + (1 + blockOrder | SubNo) + (1 + blockOrder | itemId), data = df)
summary(df.si.slopes.glm)

df.s.slopes.glm = lmer(dependent ~ 1 + blockOrder + (1 + blockOrder | SubNo), data = df)                                                                
summary(df.s.slopes.glm)

df.i.slopes.glm = lmer(dependent ~ 1 + blockOrder + (1 + blockOrder | itemId), data = df)                                                                                               
summary(df.i.slopes.glm)

#compare incl both slopes to incl only slope for subjects; test = "Chisq" is default
#anova(df.reduced, df.si.slopes.glm, test = "Chisq")
anova(df.si.slopes.glm, df.s.slopes.glm)                                 
anova(df.si.slopes.glm, df.i.slopes.glm)         










### note melt does not work properly if shape is attached rather than shape2; 
#if shape is attached, need to do this to get correct column headers
#dat.bias.test <- melt(dat.bias.test, measure.vars = c("bias1ACC", "bias2ACC"), value.name = "lexBias", variable.name = "biasQuestion") 
#dat.bias.test$biasQuestion = dat.bias.test$variable
#dat.bias.test$variable <- NULL
#dat.bias.test$lexBias = dat.bias.test$value
#dat.bias.test$value <- NULL
#colnames(dat.bias.test)
#dat.bias.test[1:3, ]


#chi-squared test  -- is biasACC reliably different across block orders (in this case just for trial 1 and only when motion events are seen in block2)
#chisq.test(df2$biasACC, df2$blockOrder)

