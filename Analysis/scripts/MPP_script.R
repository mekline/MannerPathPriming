# #set directory
# dir = setwd("~/Documents/R_stuff/MPP")
# #name of info file
# nameMetaFile = "MannerPath_data.csv"
# 

#set directories; might need to change this on your comp!
repodir = "/Users/mekline/Dropbox/_Projects/PrimingMannerPath/MannerPathPriming/"
adir = paste(repodir, "Analysis/", sep="")
ddir = paste(repodir, "MPP_Stim_and_Data/data/" , sep="")

#name of info file
nameMetaFile = paste(repodir,"MannerPath_data.csv",sep="")

####################################################################################
####################################################################################

#get all .dat files in the directory
files = list.files(ddir, pattern = ".dat$")

#create an empty error vector
error_files = c()

#generate an empty data frame for output
output = data.frame(EXPERIMENT = '', TRIAL = '',BIAS = '',TEST = '', SUBNUM = '', DAYSOLD = '', AGEYEARS = '', INCDECISION = '', stringsAsFactors=F)

#load the info data file
setwd(adir)
meta = read.csv(nameMetaFile, sep = ",", header = T)

setwd(ddir)

#loop over files (participants) and the rows in the file
#MK hack - MPP_1 and MPP_2 are formatted differently, so I hid them in a subfolder!
#And currently, this skips the .dat files of all extension participants (anyone with extra columns...)

i=1 #This counter keeps track of the size of the output file (since participants have unpredictable # of trials)
for (j in 1:length(files))
{
  file = files[j]

  #read in the file
  #If instead of a table we get an error message, move on!
  data = try(read.table(file, sep = ",", header = T))
  if (length(data) == 1) {next}
  
  #test if there is data in that file, else place in the error vector
  if (length(data[,1]) > 0)
  {
    #get info for current participant
    info = meta[meta$Participant.. == data$SubjectNo[1],]
    for (row in 1:length(data[,1]))
    {
      
      #store experiment and trialnumber
      output[i,1] = toString(data$Experiment[row])
      output[i,2] = data$trialNo[row]
      #transform variables into BIAS and TEST
      if (data$mannerSideBias[row] == "L" & data$kidResponseBias[row] == "z") output[i,3] = "MANNERBIAS"
      if (data$pathSideBias[row] == "R" & data$kidResponseBias[row] == "c") output[i,3] = "PATHBIAS"  
      if (data$mannerSideBias[row] == "R" & data$kidResponseBias[row] == "c") output[i,3] = "MANNERBIAS"
      if (data$pathSideBias[row] == "L" & data$kidResponseBias[row] == "z") output[i,3] = "PATHBIAS"
      
      if (data$mannerSideTest[row] == "L" & data$kidResponseTest[row] == "z") output[i,4] = "MANNERBIAS"
      if (data$pathSideTest[row] == "R" & data$kidResponseTest[row] == "c") output[i,4] = "PATHBIAS"  
      if (data$mannerSideTest[row] == "R" & data$kidResponseTest[row] == "c") output[i,4] = "MANNERBIAS"
      if (data$pathSideTest[row] == "L" & data$kidResponseTest[row] == "z") output[i,4] = "PATHBIAS"
     
      #Store subject number, days old, age in years and inclusion criteria
      output[i,5] = data$SubjectNo[row]
      output[i,6] = info$Days.Old
      output[i,7] = info$Age.Years
      output[i,8] = info$Inclusion.Decision
      
      i = i+1 #Next row

    }
  }
  else
  {append(error_files, file)}
}

#save data frame
setwd(adir)
write.csv(output, file = paste("all", ".csv", sep = ""))

#show errors
error_files


#To get last unique rows...
#d[ !duplicated(d$x,fromLast=TRUE), ]