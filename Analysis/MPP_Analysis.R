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

######
# LIBRARIES, FILES, DIRECTORIES
######

library(dplyr)
library(tidyr)
rm(list=ls()) #Clear any lingering variables


#Set directories; you might need to change this on your computer!
repodir = "/Users/mekline/Dropbox/_Projects/PrimingMannerPath/MannerPathPriming/"
adir = paste(repodir, "Analysis/", sep="")
ddir = paste(repodir, "MPP_Stim_and_Data/Data/" , sep="")
setwd(repodir)

pFile = paste(repodir,"MannerPath_Data.csv",sep="") #get files ready...
files = list.files(ddir, pattern = ".dat$") #get all .dat files in the directory
error_files = list() #create an empty error list
participantData = read.csv(pFile, sep = ",", header = T) #load the info data file

######
# INCLUSION INFO
######

#PLACEHOLDER: Do inclusion/exclusion of participants here, with calculations for type

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
# - Lots of errors are printed anytime we hit a badly formatted .dat file:
# as of 5/4/16 26 files do not load at the pt, because fuss-outs & exp errors sometimes
#also broke the data file too. See MPP_data.csv for inclusion/exclusion
# - 5/4/16: SOMETHING IS UP WITH 64-77, MAY NEED TO RECODE FROM VIDEO or figure out what's wrong with the files!


setwd(ddir)
allData <- data.frame(NULL)

for (file in files) {
  isError = FALSE  
  trialData = try(read.table(file, sep = ",", header = T))  #read in the file  
  if (is.data.frame(trialData)) { #test if there is data in that file, else place in the error vector
      if (nrow(trialData) > 2) {
        
        pData = try(participantData[participantData$Participant.. == trialData$SubjectNo[1],]) #get info for current participant
        pData$SubjectNo = pData$Participant..      
        myData = left_join(trialData, pData, by="SubjectNo") #Build rows
        allData <- bind_rows(myData, allData) #Add these rows to the giant data frame
        
      } else {
        isError = 1
      }
  } else {
    isError = 2
  }  
  if (isError) {
    error_files[[length(error_files) + 1]] <- file  
  }
} 

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
  
allData1 <- allData %>% #A few participants had the extension trials coded on the same lines as trials 1-8
  filter(is.na(extAnswer))
allData2 <- allData %>%
  filter(!is.na(extAnswer)) 

#this could all be a gather prob., but it aint working
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

allData <- select(allData1, -c(extAnswer, extVerbName, extMannerSide, extPathSide)) %>%
  rbind(allDataBase) %>%
  rbind(allDataExtend) %>%
  arrange(SubjectNo) %>%
  select(Experiment,Condition,SubjectNo,trialNo,itemID,verbName, mannerSideBias:Exclude.Reason) #just reordering

rm(list=setdiff(ls(), c("allData","adir","ddir","repodir")))#avoid accidentally referencing placeholder vars from above

allData <- allData %>%
  filter(Inclusion.Decision == 1) %>% #Eventually do this above and report stats!
  select(-c(Inclusion.Decision, Exclude.Reason))

######
# LIBRARIES, FILES, DIRECTORIES
######




#       
#       #transform variables into BIAS and TEST
#       if (data$mannerSideBias[row] == "L" & data$kidResponseBias[row] == "z") output[counter,3] = "MANNERBIAS"
#       if (data$pathSideBias[row] == "R" & data$kidResponseBias[row] == "c") output[counter,3] = "PATHBIAS"  
#       if (data$mannerSideBias[row] == "R" & data$kidResponseBias[row] == "c") output[counter,3] = "MANNERBIAS"
#       if (data$pathSideBias[row] == "L" & data$kidResponseBias[row] == "z") output[counter,3] = "PATHBIAS"
#       
#       if (data$mannerSideTest[row] == "L" & data$kidResponseTest[row] == "z") output[counter,4] = "MANNERBIAS"
#       if (data$pathSideTest[row] == "R" & data$kidResponseTest[row] == "c") output[counter,4] = "PATHBIAS"  
#       if (data$mannerSideTest[row] == "R" & data$kidResponseTest[row] == "c") output[counter,4] = "MANNERBIAS"
#       if (data$pathSideTest[row] == "L" & data$kidResponseTest[row] == "z") output[counter,4] = "PATHBIAS"
