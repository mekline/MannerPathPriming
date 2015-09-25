#Just an R file to automagically make the names of the audio files for Annelot :)
setwd("~/Dropbox/_Projects/PrimingMannerPath/MannerPathPriming")

items = read.csv("Experiment_Items_final.csv", header = TRUE, stringsAsFactors = FALSE)

#Add columns with the object for each critical video: original and train 1-3

items$ambigV <- as.character(items$ambigV)
items$trainV1 <- as.character(items$trainV1)
items$trainV2 <- as.character(items$trainV2)
items$trainV3 <- as.character(items$trainV3)

getObj <- function(mystring){
  wordz = strsplit(mystring,'.',fixed = TRUE)
  return(unlist(wordz)[3])
}

items$wordamb <- sapply(items$ambigV,getObj)
items$word1 <- sapply(items$trainV1,getObj)
items$word2 <- sapply(items$trainV2,getObj)
items$word3 <- sapply(items$trainV3,getObj)

#Now build the filenames!
items$cond <- 'manner'
items[items$Condition == 'Path',]$cond <- 'path'
items[items$Condition == 'Effect',]$cond <- 'path'

items$ambigAudioFuture <- paste(items$verbName, items$cond, 'future', items$wordamb, sep='_' )
items$ambigAudioPast <- paste(items$verbName, items$cond, 'past', items$wordamb, sep='_' )
items$trainAudioFuture1 <- paste(items$verbName, items$cond, 'future', items$word1, sep='_' )
items$trainAudioPast1 <- paste(items$verbName, items$cond, 'past', items$word1, sep='_' )
items$trainAudioFuture2 <- paste(items$verbName, items$cond, 'future', items$word2, sep='_' )
items$trainAudioPast2 <- paste(items$verbName, items$cond, 'past', items$word2, sep='_' )
items$trainAudioFuture3 <- paste(items$verbName, items$cond, 'future', items$word3, sep='_' )
items$trainAudioPast3 <- paste(items$verbName, items$cond, 'past', items$word3, sep='_' )

items$ambigAudioFuture <- paste(items$ambigAudioFuture, 'wav', sep='.' )
items$ambigAudioPast <- paste(items$ambigAudioPast, 'wav', sep='.' )
items$trainAudioFuture1 <- paste(items$trainAudioFuture1, 'wav', sep='.' )
items$trainAudioPast1 <- paste(items$trainAudioPast1, 'wav', sep='.' )
items$trainAudioFuture2 <- paste(items$trainAudioFuture2, 'wav', sep='.' )
items$trainAudioPast2 <- paste(items$trainAudioPast2, 'wav', sep='.' )
items$trainAudioFuture3 <- paste(items$trainAudioFuture3, 'wav', sep='.' )
items$trainAudioPast3 <- paste(items$trainAudioPast3, 'wav', sep='.' )

#Clean up the file a bit before saving it
items <- subset(items, select=-c(wordamb, word1, word2, word3, cond))
write.csv(items, "Experiment_Items_final_withaudio.csv")
#IMPORTANT NOTE: After export, we have to change/check one item: Birking-manner.  In this item, there
#are 2 training trials with a spaceship object (around and into), so we'll manually rename those
#objects spaceship and spaceship2 and make sure audio files are named accordingly.
