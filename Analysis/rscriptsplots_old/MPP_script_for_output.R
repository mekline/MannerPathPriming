dir = setwd("/Users/AnneCharlotte/Documents/R_stuff/MPP")
files = list.files(dir, pattern = ".dat$")

error_files = c()
for (file in files)
{
  data = read.table(file, sep = ",", header = T)
  output = data.frame(EXPERIMENT = '', TRIAL = '',BIAS = '',TEST = '', stringsAsFactors=F)
  if (length(data[,1]) > 0)
  {
    for (row in 1:length(data[,1]))
    {
      output[row,1] = toString(data$Experiment[row])
      output[row,2] = data$trialNo[row]
      
      if (data$mannerSideBias[row] == "L" & data$kidResponseBias[row] == "z") output[row,3] = "MANNERBIAS"
      if (data$pathSideBias[row] == "R" & data$kidResponseBias[row] == "c") output[row,3] = "PATHBIAS"  
      if (data$mannerSideBias[row] == "R" & data$kidResponseBias[row] == "c") output[row,3] = "MANNERBIAS"
      if (data$pathSideBias[row] == "L" & data$kidResponseBias[row] == "z") output[row,3] = "PATHBIAS"
  
      if (data$mannerSideTest[row] == "L" & data$kidResponseTest[row] == "z") output[row,4] = "MANNERBIAS"
      if (data$pathSideTest[row] == "R" & data$kidResponseTest[row] == "c") output[row,4] = "PATHBIAS"  
      if (data$mannerSideTest[row] == "R" & data$kidResponseTest[row] == "c") output[row,4] = "MANNERBIAS"
      if (data$pathSideTest[row] == "L" & data$kidResponseTest[row] == "z") output[row,4] = "PATHBIAS"
    }
  
    name =   substr(file, 1, nchar(file)-4)
    write.csv(output, file = paste(name, ".csv", sep = ""))
  }
  else
  {append(error_files, file)}
}

error_files