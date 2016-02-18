#set directory
dir = setwd("~/Documents/R_stuff/MPP")
#name of info file
nameMetaFile = "MannerPath_Data.csv"


####################################################################################
####################################################################################

#get all .dat files in the directory
files = list.files(dir, pattern = ".dat$")

#create an empty error vector
error_files = c()

#counter to count at which row in the data frame we are
counter = 1

#generate an empty data frame for output
output = data.frame(EXPERIMENT = '', TRIAL = '',BIAS = '',TEST = '', SUBNUM = '', DAYSOLD = '', AGEYEARS = '', INCDECISION = '', stringsAsFactors=F)

#load the info data file
meta = read.csv(nameMetaFile, sep = ",", header = T)

#loop over files (participants) and the rows in the file
for (file in files)
{
  #read in the file
  data = read.table(file, sep = ",", header = T)
  
  #test if there is data in that file, else place in the error vector
  if (length(data[,1]) > 0)
  {
    #get info for current participant
    info = meta[meta$Participant.. == data$SubjectNo[1],]
    for (row in 1:length(data[,1]))
    {
      
      #store experiment and trialnumber
      output[counter,1] = toString(data$Experiment[row])
      output[counter,2] = data$trialNo[row]
      
      #transform variables into BIAS and TEST
      if (data$mannerSideBias[row] == "L" & data$kidResponseBias[row] == "z") output[counter,3] = "MANNERBIAS"
      if (data$pathSideBias[row] == "R" & data$kidResponseBias[row] == "c") output[counter,3] = "PATHBIAS"  
      if (data$mannerSideBias[row] == "R" & data$kidResponseBias[row] == "c") output[counter,3] = "MANNERBIAS"
      if (data$pathSideBias[row] == "L" & data$kidResponseBias[row] == "z") output[counter,3] = "PATHBIAS"
      
      if (data$mannerSideTest[row] == "L" & data$kidResponseTest[row] == "z") output[counter,4] = "MANNERBIAS"
      if (data$pathSideTest[row] == "R" & data$kidResponseTest[row] == "c") output[counter,4] = "PATHBIAS"  
      if (data$mannerSideTest[row] == "R" & data$kidResponseTest[row] == "c") output[counter,4] = "MANNERBIAS"
      if (data$pathSideTest[row] == "L" & data$kidResponseTest[row] == "z") output[counter,4] = "PATHBIAS"
     
      #Store subject number, days old, age in years and inclusion criteria
      output[counter,5] = data$SubjectNo[row]
      output[counter,6] = info$Days.Old
      output[counter,7] = info$Age.Years
      output[counter,8] = info$Inclusion.Decision
      #next row
      counter = counter + 1
    }
  }
  else
  {append(error_files, file)}
}

#save data frame
write.csv(output, file = paste("all", ".csv", sep = ""))

#show errors
error_files