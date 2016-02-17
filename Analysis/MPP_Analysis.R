# This file is going to have the full analysis pipeline for the MannerPath studies!  
#It will pull data from the main MPP_Participants.csv and from the trial data
#(Repo/MPP Presentation/Data) from each child.

#To start, I'm bringing over the data cleaning (for E1 circa 1/20) Annelot did)

#set directories; might need to change this on your comp!
repodir = "/Users/mekline/Dropbox/_Projects/PrimingMannerPath/MannerPathPriming/"
adir = paste(repodir, "Analysis/", sep="")
ddir = paste(repodir, "MPP Presentation Stimuli and Trial Data/Data/" , sep="")
setwd(repodir)

#name of info file
nameMetaFile = paste(repodir,"MannerPath_Data.csv",sep="")

#START HERE

#get all .dat files in the directory
files = list.files(ddir, pattern = ".dat$")

#create an empty error vector
error_files = c()

#counter to count at which row in the data frame we are
counter = 1

#generate an empty data frame for output
output = data.frame(EXPERIMENT = '', TRIAL = '',BIAS = '',TEST = '', SUBNUM = '', DAYSOLD = '', AGEYEARS = '', INCDECISION = '', stringsAsFactors=F)

#load the info data file
meta = read.csv(nameMetaFile, sep = ",", header = T)

