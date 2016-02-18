#set directories; might need to change this on your comp!
repodir = "/Users/mekline/Dropbox/_Projects/PrimingMannerPath/MannerPathPriming/"
adir = paste(repodir, "Analysis/", sep="")
ddir = paste(repodir, "MPP Presentation Stimuli and Trial data/data/" , sep="")

#name of info file
nameMetaFile = paste(repodir,"MannerPath_data.csv",sep="")

#----------------------------------------------------------------------------------

#get all .dat files in the directory
files = list.files(ddir, pattern = ".dat$")
#create an empty error vector
error_files = c()
#counter to count at which row in the data frame we are
counter = 1
#generate an empty data frame for output
output = data.frame(EXPERIMENT = '', TRIAL = '',BIAS = '',TEST = '', SUBNUM = '', DAYSOLD = '', AGEYEARS = '', INCDECISION = '', EXT = '', stringsAsFactors=F)
#load the info data file
setwd(adir)
meta = read.csv(nameMetaFile, sep = ",", header = T)
#loop over files (participants) and the rows in the file
setwd(ddir)
for (j in 1:length(files))
{
  file = files[j]
  #print(file)
  #read in the file
  #If instead of a table we get an error message, move on!
  data = try(read.table(file, sep = ",", header = T, fill=T)) #Fill adds in NAs for blank cells :)
  if (length(data) == 1) {next}
  
  #Hack for the consolidated data folder - if it's a non-extension session, skip it! (And drop kids who didn't complete any trials...)
  if (dim(data)[2] < 50 || dim(data)[1] < 2) {next}
  
   #test if there is data in that file, else place in the error vector
  if (length(data[,1]) > 0)
  {
    #get info for current participant
    info = meta[meta$Participant.. == data$SubjectNo[1],]
    for (row in (length(data[,1])-7):length(data[,1]))
    {
      
      #store experiment and trialnumber
      #output[counter,1] = toString(data$Experiment[row])
      #whoopsy, get it from meta I guess!
      print(info$Verb.Condition)
      output[counter,1] = toString(info$Verb.Condition)
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
     
      # transform extension
      if (data$extMannerSide[row] == "L" & data$extAnswer[row] == "z") output[counter,9] = "MANNERBIAS"
      if (data$extPathSide[row] == "R" & data$extAnswer[row] == "c") output[counter,9] = "PATHBIAS"  
      if (data$extMannerSide[row] == "R" & data$extAnswer[row] == "c") output[counter,9] = "MANNERBIAS"
      if (data$extPathSide[row] == "L" & data$extAnswer[row] == "z") output[counter,9] = "PATHBIAS"
      
      
      #Store subject number, days old, age in years and inclusion criteria
      output[counter,5] = data$SubjectNo[row]
      output[counter,6] = info$Days.Old
      output[counter,7] = info$Age.Years
      output[counter,8] = info$Inclusion.Decision
      #next row
      counter = counter + 1
      
      #if(data$SubjectNo[row] == 54) print(data)
    }
 }
  else
  {append(error_files, file)}
}

#save data frame
setwd(adir)
write.csv(output, file = paste("all_ext", ".csv", sep = ""))
#show errors
error_files