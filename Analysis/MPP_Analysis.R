# This file is going to have the full analysis pipeline for the MannerPath studies!  
#It will pull data from the main MannerPath_Data.csv and from the trial data
#(Repo/MPP_Stim_and_Data/Data) from each child. There are (currently) two different
#experiments/conditions in the dataset:
#
# MannerPath - the original version (MP learning/bias), with no extension version
# ActionEffect+Extend - AE learning/bias, followed by MP trials which have only bias phase

# Just for super awesome fun times, subjects before #77 in AE-Extend have a variety of 
# slightly different matlab outputs, and some of them only have AE data but no extension.
# Hence data cleaning/reformatting is...a bit messy.  
#
# See #TODO for unfinished places
# See line 140ish for analysis

######
# LIBRARIES, FILES, DIRECTORIES
######

library(dplyr)
library(tidyr)
library(ggplot2)
library(lme4)
library(pwr)
rm(list=ls()) #Clear any lingering variables


#Set directories; might need to change this on your computer!
#repodir = "C:/Users/Anna/Documents/GitHub/MannerPathPriming/"
repodir = "/Users/mekline/Dropbox/_Projects/PrimingMannerPath/MannerPathPriming/"

adir = paste(repodir, "Analysis/", sep="")
ddir = paste(repodir, "MPP_Stim_and_Data/Data/" , sep="")
setwd(repodir)

pFile = paste(repodir,"MannerPath_Data.csv",sep="") #get files ready...
files = list.files(ddir, pattern = ".dat$") #all .dat files in data directory
participantData = read.csv(pFile, sep = ",", header = T) #load the info data file

######
# INCLUSION INFO
######

#TODO: Do inclusion/exclusion of participants up here, with calculations for type of exclusion
#Print nice summary of subject numbers, ages, gender splits up here

######
# DATA CLEANING
######

#loop over files (participants) and the rows in the file
#For now, just read in all lines of every data file. Assert that all have the same columns 
#names at the start, but some may have extra columns if they have extension data. Later on we'll
#clean up and reshape to get nicer formatted data.

#Notes: 
# - No .dat files for 1,2, 35, 42, 69 (1-2 pilot, 35-69 kids who consented/are on camera
# but didn't get to the exp)
#
# - Lots of errors are printed anytime we hit a badly formatted .dat file

setwd(ddir)
allData <- data.frame(NULL)

error_files = list() #create an empty error list
for (file in files) {
  
  trialData <- try(read.table(file, sep = ",", header = T, fill=T))
  if (class(trialData) == 'try-error') {
    cat(file)
    cat('Caught an error during read.table.\n')
  } else { 
      pData = try(participantData[participantData$Participant.. == trialData$SubjectNo[1],]) #get info for current participant
      pData$SubjectNo = pData$Participant..  
      myData = left_join(trialData, pData, by="SubjectNo") #Build rows
      allData <- bind_rows(myData, allData) #Add these rows to the giant data frame
  } 
} 
length(unique(allData$SubjectNo))


#It's a great big data frame! Begin by dropping columns that we don't need for analysis (mostly names of individual vid files)
colToSave = c("SubjectNo","VerbDomain","trialNo","itemID",
              "verbName","mannerSideBias","pathSideBias",
              "kidResponseBias","mannerSideTest","pathSideTest",
              "kidResponseTest","Experiment","Verb.Condition",
              "Gender","Days.Old",
              "Age.Years","Age.Months","Inclusion.Decision",
              "Exclude.Reason","Experiment.Group",
              "Experiment.x","Experiment.y","Condition",
              "extAnswer","extVerbName",
              "extMannerSide","extPathSide")


#Recode variable names
allData$RealExp <- ''
allData$Experiment <- as.character(allData$Experiment)
allData$Experiment.y <- as.character(allData$Experiment.y)
allData <- allData  %>%
  select(one_of(colToSave)) %>%
  mutate(RealExp = ifelse(is.na(Experiment),Experiment.y,Experiment)) %>% #'Experiment' and 'Condition' were used inconsistently early on but can be derived from levels used
  select(-c(VerbDomain, Experiment, Experiment.Group, Experiment.y, Experiment.x, Condition)) %>%
  rename(Experiment = RealExp) %>%
  rename(Condition = Verb.Condition)
  
allData1 <- allData %>% #A few participants had the extension trials coded on the same lines as trials 1-8, just have to rearrange them
  filter(is.na(extAnswer))
allData2 <- allData %>%
  filter(!is.na(extAnswer)) 

#this could all be a gather probably, but it aint working
allDataBase <- select(allData2, -c(extAnswer, extVerbName, extMannerSide, extPathSide))
allDataExtend <- select(allData2, -c(itemID,verbName,mannerSideBias,pathSideBias,kidResponseBias,mannerSideTest,pathSideTest,kidResponseTest))

allDataExtend <- allDataExtend %>%
  mutate(trialNo = trialNo + 8) %>%
  rename(verbName = extVerbName)  %>%
  rename(mannerSideBias = extMannerSide) %>%
  rename(pathSideBias = extPathSide) %>%
  rename(kidResponseBias = extAnswer)

allDataExtend$itemID = 'get it from verbname'
allDataExtend$mannerSideTest = 'undefined'
allDataExtend$pathSideTest = 'undefined'
allDataExtend$kidResponseTest = 'undefined'

allData <- select(allData1, -c(extAnswer, extVerbName, extMannerSide, extPathSide)) %>% #re-adding the normal ones
  rbind(allDataBase) %>% #add base, then ext. trials of the weirdos
  rbind(allDataExtend) %>%
  arrange(SubjectNo) %>%
  select(Experiment,Condition,SubjectNo,trialNo,itemID,verbName, mannerSideBias:Exclude.Reason) #just reordering

#rm(list=setdiff(ls(), c("allData","adir","ddir","repodir")))#avoid accidentally referencing placeholder vars from above

allData <- allData %>%
  filter(!is.na(Inclusion.Decision)) %>%
  filter(Inclusion.Decision == 1) %>% #TODO: Eventually do this above and report stats!
  select(-c(Inclusion.Decision, Exclude.Reason))


######
# DATA RESHAPE FOR ANALYSIS & GRAPHS
######

#TODO: Probably a good idea to print out a sanitized csv here for people who don't want to run the data cleaning....

#TODO: Checks for effects of side bias go here

allData <- allData %>% #Translate kid choice variables to objective 'choseM' for Bias (main) & Test (sanity check - did they learn the verb)
  filter(kidResponseBias == 'z' | kidResponseBias == 'c') %>% #remove trials w/ no answer on critical Bias q
  mutate(choseM.Bias = ifelse((mannerSideBias == "L" & kidResponseBias == "z")| 
                                     (mannerSideBias == "R" & kidResponseBias == "c"), 1, 0)) %>% 
  mutate(choseM.Test = ifelse((mannerSideTest == "L" & kidResponseTest == "z")| 
                                (mannerSideTest == "R" & kidResponseTest == "c"), 1, 0)) %>%
  
  mutate(expPhase = ifelse(trialNo>8,"Extension","Base")) #Mark trials 1-8 and 9-16


######
#IMPORTANT!
######
allData <- filter(allData, trialNo>1) #Trial #1 Bias test is pre-training!!
#Anna run to here

######
# GRAPHS
######

makePlot = function(ydata, ylab="proportion chosing Manner/Action", title=""){
  
  plotData <- aggregate(ydata$choseM.Bias, by=list(ydata$Condition,  ydata$trialNo), sum)
  numObs <- aggregate(ydata$choseM.Bias, by=list(ydata$Condition, ydata$trialNo), length)
  names(plotData) <- c("Condition", "trialNo", "choseManner")
  plotData$numObs <- numObs$x

  #get the binomial conf.intervals per condition per trial
  for (cond in unique(plotData$Condition))
  {
    for (trial in unique(plotData[plotData$Condition == cond,]$trialNo))
    {
      x = plotData[plotData$Condition == cond & plotData$trialNo == trial,]$choseManner
      n = plotData[plotData$Condition == cond & plotData$trialNo == trial,]$numObs
      
      test = prop.test(x, n, conf.level=0.95)
      plotData$intLower[plotData$Condition == cond & plotData$trialNo == trial] = test$conf.int[1]
      plotData$intUpper[plotData$Condition == cond & plotData$trialNo == trial]  = test$conf.int[2]
      plotData$theAvg[plotData$Condition == cond & plotData$trialNo == trial] = x/n
    }
  }

  #print(plotData)
  #make a plot with ggplot
  pd <- position_dodge(0.1)
  
  ggplot(plotData, aes(x=trialNo, y=theAvg, colour=Condition, group=Condition, ymax = 1)) + 
    geom_errorbar(aes(ymin=intLower, ymax=intUpper), colour="black", width=.1, position=pd) +
    geom_line(position=pd) +
    ylab(ylab) +
    geom_point(position=pd, size=3) +
    coord_cartesian(ylim=c(0,1)) +
    ggtitle(title)
  #scale_colour_manual(values = c("green","red"),
  #name="",
  #labels=c("Manner", "Path")) +
}

makePlot(filter(allData, Condition == "Manner" | Condition == "Path"))
makePlot(filter(allData, Condition == "Action" | Condition == "Effect"))

makeBar = function(ydata, ylab="proportion chosing Manner/Action", title="") {
  
  plotData <- aggregate(ydata$choseM.Bias, by=list(ydata$Condition, ydata$expPhase), sum)
  numObs <- aggregate(ydata$choseM.Bias, by=list(ydata$Condition, ydata$expPhase), length)
  names(plotData) <- c("Condition", "Phase", "choseManner")
  plotData$numObs <- numObs$x
  print(plotData)
  
  
  for (cond in unique(plotData$Condition)){
    for (ph in unique(plotData$Phase)){
      x = plotData[plotData$Condition == cond & plotData$Phase == ph,]$choseManner
      n = plotData[plotData$Condition == cond & plotData$Phase == ph,]$numObs
      
      test = prop.test(x, n, conf.level=0.95)
      plotData$intLower[plotData$Condition == cond & plotData$Phase == ph] = test$conf.int[1]
      plotData$intUpper[plotData$Condition == cond & plotData$Phase == ph]  = test$conf.int[2]
      plotData$theAvg[plotData$Condition == cond & plotData$Phase == ph] = x/n
    }
    
  }
  

  ggplot(plotData, aes(x=Phase, y=theAvg, fill=Condition)) + 
    geom_bar(position=position_dodge(), stat="identity") +
    geom_errorbar(aes(ymin=intLower, ymax=intUpper), colour="black", width=.1, position=position_dodge(.9)) + #Why point 9? Hell if I know!
    coord_cartesian(ylim=c(0,1))+
    ylab(ylab)+
    xlab('')+
    theme_bw()+
    #scale_colour_manual(values = c("green","red")) +
    #scale_fill_brewer(palette=colors) +
    ggtitle(title)
}

makeBar(filter(allData, Condition == "Manner" | Condition == "Path"))
makeBar(filter(allData, Condition == "Action" | Condition == "Effect"))

######
# ANALYSIS
######

# SUMMARY/DESCRIPTIVE STATISTICS

#How many S's included? Collapse to 'chose manner' score rather than individual trial responses - notice for 'extend' this collapses the 2 experiment phases, DON"T use these for stats, jsut S level info :)
scoreData <- aggregate(allData$choseM.Bias, by=list(allData$Experiment, allData$Condition, allData$SubjectNo), sum)
names(scoreData) <- c("Experiment", "Condition", "SubNo", "choseMScore")
table(scoreData$Experiment, scoreData$Condition)

# CONFIRMATORY/PLANNED ANALYSES

#Note first Bias trial was removed above; it tells us nothing, no evidence has been seen yet!
Exp1 <- filter(allData, Experiment == "E1 - MannerPath")
Exp2.Base <- filter(allData, Experiment == "E2 - ActionEffect extend to MannerPath" & expPhase == "Base")
Exp2.Extend <- filter(allData, Experiment == "E2 - ActionEffect extend to MannerPath" & expPhase == "Extension")

#Test 1: Does CONDITION matter? (Random effects for verbs; Condition is between-subjects)

#Exp1
model_eff <- glmer(choseM.Bias ~ Condition  + (1|verbName), data=Exp1, family="binomial")
model_noeff <- glmer(choseM.Bias ~ 1  + (1|verbName), data=Exp1, family="binomial")
anova(model_eff, model_noeff)

#Exp2 base
model_eff2 <- glmer(choseM.Bias ~ Condition  + (1|verbName), data=Exp2.Base, family="binomial")
model_noeff2 <- glmer(choseM.Bias ~ 1  + (1|verbName), data=Exp2.Base, family="binomial")
anova(model_eff2, model_noeff2)

#Exp2 Extension
model_eff3 <- glmer(choseM.Bias ~ Condition  + (1|verbName), data=Exp2.Extend, family="binomial")
model_noeff3 <- glmer(choseM.Bias ~ 1  + (1|verbName), data=Exp2.Extend, family="binomial")
anova(model_eff3, model_noeff3)


# Test #2
# Do exp and trial interact? That is, is the different between exp different later in the exp? Do they diverge? 
# 5/6/16 - Not that we can detect
#

#Exp1
model_inter <- glmer(choseM.Bias ~ Condition*trialNo + (1|verbName), data=Exp1, family="binomial")
model_nointer <- glmer(choseM.Bias ~ Condition+trialNo + (1|verbName), data=Exp1, family="binomial")
model_tonly <- glmer(choseM.Bias ~ trialNo + (1|verbName), data=Exp1, family="binomial")

anova(model_inter, model_nointer)
anova(model_nointer, model_tonly)

#Exp2 - Base
model_inter2 <- glmer(choseM.Bias ~ Condition*trialNo + (1|verbName), data=Exp2.Base, family="binomial")
model_nointer2 <- glmer(choseM.Bias ~ Condition+trialNo + (1|verbName), data=Exp2.Base, family="binomial")
model_tonly2 <- glmer(choseM.Bias ~ trialNo + (1|verbName), data=Exp2.Base, family="binomial")

anova(model_inter2, model_nointer2)
anova(model_nointer2, model_tonly2)

#Exp2 - Extension
model_inter3 <- glmer(choseM.Bias ~ Condition*trialNo + (1|verbName), data=Exp2.Extend, family="binomial")
model_nointer3 <- glmer(choseM.Bias ~ Condition+trialNo + (1|verbName), data=Exp2.Extend, family="binomial")
model_tonly3 <- glmer(choseM.Bias ~ trialNo + (1|verbName), data=Exp2.Extend, family="binomial")

anova(model_inter3, model_nointer3)
anova(model_nointer3, model_tonly3)

#ADDITIONAL PLANNED ANALYSES:

#Manipulation check: Logistic models paralleling the above testing whether children answer more correctly than chance at the END of each verb-learning trial
#That is, we'll test whether the 2 conditions are reliably different from each other on the Test trials. 


#Because power is low and children are noisy data, we will also use this 'actually learned' measure to calculate a score for each participant. We can then
#test the subset of children who answered > 4 out of 8 correctly on the above measures. This may provide us a biased sample of 'attentive' 4-5yos; we can 
#see whether this subgroup performs in the expected way on the above measures. 

#Age: We will enter age (days old) as an additional factor in the models above to see if we can detect any effects of age on priming/extension in these tasks. 
# but this design is probably not going to be sensitive to detect them. 

#EXPLORATORY ANALYSES

#...tbd


######
# For reference!!
######

# POWER CALCULATION
#(this is how we set sample sizes for e2 onward)

#Let's assume gods of CLT smiled & those are normally enough distributed.  Power calculations!!!
#(NOTE: we use a 1 sided t test for power calculations because of not being sure how to
#correctly run power analyses for the lmms correctly. These power calculations are probably 
#generous.)

#6/2/16 Power calculation for determining sample sizes to be used in Exp2 onward

Exp1 <- filter(allData, Experiment == "E1 - MannerPath")
pwrData <- aggregate(Exp1$choseM.Bias, by=list(Exp1$Condition, Exp1$SubjectNo), sum)
names(pwrData) <- c("Condition", "SubNo", "choseMScore")
#Each S now has a score from 0 to 7 (= n of times chose M on bias phase of trials 2-8)

mm <- filter(pwrData, Condition == "Manner")$choseMScore
pp <- filter(pwrData, Condition == "Path")$choseMScore
pooled_sd <- sqrt((sd(mm)^2 + sd(pp)^2)/2)

d <- (mean(mm)-mean(pp))/pooled_sd
n <-min(length(mm), length(pp)) #per cell!!

#This test indicates that our power is 0.24 in Exp 1 (pilot, M/P training only). Yikes!
pwr.t.test(d=d,n=n,sig.level=0.05, type="two.sample", alternative="greater") #We test the h that kids are more likely to make manner choices after manner training

#We would like to have power = .80, but we would also like to run a # of subjects that is in our budget. How bad is pwr = 0.8?
pwr.t.test(d=d,power = 0.8, sig.level=0.05, type="two.sample", alternative="greater") #We test the h that kids are more likely to make manner choices after manner training

#99/cell is wildly outside what we can afford to test. Havasi used 32/cell: 
pwr.t.test(d=d,n=32, sig.level=0.05, type="two.sample", alternative="greater") 

#...which is still very underpowered.  We will therefore plan to run Exp 2 to 32/cell, and if 
# that is nonsignificant, continue to 64/cell (100% increase, pwr=0.6). Whatever # is 
#reached in this procedure will be fixed for all subsequent experiments.
pwr.t.test(d=d,n=64, sig.level=0.05, type="two.sample", alternative="greater") 



