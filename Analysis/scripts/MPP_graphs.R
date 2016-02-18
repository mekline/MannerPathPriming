#set path
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
      print(cond)
      print(trial)
      print(n)
      print(x)
      }
    }
    
    #make a plot with ggplot
    pd <- position_dodge(0.1)
    
    ggplot(plotData, aes(x=verb, y=pathmean, colour=cond, group=cond)) + 
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