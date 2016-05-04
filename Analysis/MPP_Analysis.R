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

library(dplyr)

#Clear any lingering variables
rm(list=ls())

#set directories; you might need to change this on your computer!
repodir = "/Users/mekline/Dropbox/_Projects/PrimingMannerPath/MannerPathPriming/"
adir = paste(repodir, "Analysis/", sep="")
ddir = paste(repodir, "MPP_Stim_and_Data/Data/" , sep="")
setwd(repodir)

#name of info file
nameMetaFile = paste(repodir,"MannerPath_Data.csv",sep="")

#get all .dat files in the directory
files = list.files(ddir, pattern = ".dat$")

#create an empty error list
error_files = list()

#load the info data file
participantData = read.csv(nameMetaFile, sep = ",", header = T)


#loop over files (participants) and the rows in the file
#Here melissa starts making some changes to read in both regular and extension data in a flexible way...

#The goal: For now, just read in all lines of every data file. Assert that all have the same columns 
#names at the start, but some may have extra columns if they have extension data. Later on we'll
#clean up and reshape to get nicer formatted data.

#Notes: 
# - No .dat files for 1,2, 35, 42, 69 (1-2 pilot, 35-69 kids who consented
# but didn't get to the exp)
#
# - Lots of errors are printed anytime we hit a badly formatted .dat file:
# as of 5/4/16 26 files do not load at the pt, because fuss-outs & exp errors 
#almost always broke the data file too. See MPP_data.csv for inclusion/exclusion
# - 5/4/16: SOMETHING IS UP WITH 71-77, MAY NEED TO RECODE FROM VIDEO


setwd(ddir)
allData <- data.frame(NULL)

for (file in files) {
  isError = FALSE
  
  #read in the file
  trialData = try(read.table(file, sep = ",", header = T))  
   
  #test if there is data in that file, else place in the error vector
  if (is.data.frame(trialData)) {
      if (nrow(trialData) > 2) {

        #get info for current participant
        pData = try(participantData[participantData$Participant.. == trialData$SubjectNo[1],])
    
        #Build out the rows for this participant
        
        #Add these rows to the giant data frame
        allData <- bind_rows(pData, allData)
      } else {
        isError = TRUE
      }
  } else {
    isError = TRUE
  }
  
  if (isError) {
    error_files[[length(error_files) + 1]] <- file    
  }

} 




#     for (row in 1:length(data[,1]))
#     {
#       
#       #store experiment and trialnumber
#       output[counter,1] = toString(data$Experiment[row])
#       output[counter,2] = data$trialNo[row]
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
#       
#       #Store subject number, days old, age in years and inclusion criteria
#       output[counter,5] = data$SubjectNo[row]
#       output[counter,6] = info$Days.Old
#       output[counter,7] = info$Age.Years
#       output[counter,8] = info$Inclusion.Decision
#       #next row
#      counter = counter + 1
#    }