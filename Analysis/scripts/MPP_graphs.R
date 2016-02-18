#set path
setwd("/Users/mekline/Dropbox/_Projects/PrimingMannerPath/MannerPathPriming/Analysis/")
data = read.csv('all.csv', sep = ",", header = T)

#load libraries
library(ggplot2)

#load data
data = read.csv('all.csv', sep = ",", header = T)

#new variables
data$pathTEST[data$TEST == 'PATHBIAS'] = 1
data$pathTEST[data$TEST == 'MANNERBIAS'] = 0
data$pathBIAS[data$BIAS == 'PATHBIAS'] = 1
data$pathBIAS[data$BIAS == 'MANNERBIAS'] = 0

#Remove NA levels (really elsewhere we should document what happened to those lines!)
data <- data[!is.na(data$EXPERIMENT), ]
data <- data[!is.na(data$TRIAL), ]

#Debugging the binomial testing
# for (cond in unique(data$EXPERIMENT))
# {
#   for (trial in unique(data$TRIAL))
#   {
#     n = length(data[data$EXPERIMENT == cond & data$TRIAL == trial,]$pathBIAS)
#     x = sum(data[data$EXPERIMENT == cond & data$TRIAL == trial,]$pathBIAS, na.rm=TRUE)
#     test = prop.test(x, n, conf.level=0.95)
#     #plotData$intLower[plotData$cond == cond & plotData$verb == trial] = test$conf.int[1]
#     #plotData$intUpper[plotData$cond == cond & plotData$verb == trial]  = test$conf.int[2]
#     print('set')
#     print(x/n)
#     print(test$conf.int[1])
#     print(test$conf.int[2])
#   }
# }


makePlot = function(ydata, title="")
{
    #aggregate data to get mean per trial per condition
    plotData = aggregate(x = list(pathmean = ydata), by = list( cond = data$EXPERIMENT, verb = data$TRIAL), FUN = mean)
    
    #get the binomial conf.intervals per condition per trial
    for (cond in unique(data$EXPERIMENT))
    {
      for (trial in unique(data$TRIAL))
      {
        n = length(ydata[data$EXPERIMENT == cond & data$TRIAL == trial])
        x = sum(ydata[data$EXPERIMENT == cond & data$TRIAL == trial])
        test = prop.test(x, n, conf.level=0.95)
        plotData$intLower[plotData$cond == cond & plotData$verb == trial] = test$conf.int[1]
        plotData$intUpper[plotData$cond == cond & plotData$verb == trial]  = test$conf.int[2]
      print(test$conf.int[1])
      print(test$conf.int[2])
      #print(n)
      #print(x)
      }
    }
    
    #make a plot with ggplot
    pd <- position_dodge(0.1)
    
    ggplot(plotData, aes(x=verb, y=pathmean, colour=cond, group=cond, ymax = 1)) + 
      geom_errorbar(aes(ymin=intLower, ymax=intUpper), colour="black", width=.1, position=pd) +
      geom_line(position=pd) +
      ylab("Proportion of Path Responses") +
      geom_point(position=pd, size=3) +
      scale_colour_manual(values = c("green","red"),
                          name="",
                          labels=c("Manner", "Path")) +
    ggtitle(title)
}

makePlot(data$pathTEST, "Final Test")
makePlot(data$pathBIAS, "Bias Test")