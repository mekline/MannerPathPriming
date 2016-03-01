#set path
setwd("/Users/mekline/Dropbox/_Projects/PrimingMannerPath/MannerPathPriming/Analysis/")

#load libraries
library(ggplot2)

#CLear history!!!
rm(list=ls())

#load data
data = read.csv('all_ext.csv', sep = ",", header = T)
doExtension = 1

#Drop participants
data <- data[!is.na(data$INCDECISION),]
data <- data[data$INCDECISION == 1,]
length(unique(data$SUBNUM))

#new variables
data$pathTEST[data$TEST == 'PATHBIAS'] = 1
data$pathTEST[data$TEST == 'MANNERBIAS'] = 0
data$pathBIAS[data$BIAS == 'PATHBIAS'] = 1
data$pathBIAS[data$BIAS == 'MANNERBIAS'] = 0
data$pathEXT[data$EXT == 'PATHBIAS'] = 1
data$pathEXT[data$EXT == 'MANNERBIAS'] = 0


dim(data)
#Remove NA levels (really elsewhere we should document what happened to those lines!)
data <- data[!is.na(data$EXPERIMENT), ]
data <- data[!is.na(data$TRIAL), ]
if (doExtension){
  data <- data[!is.na(data$EXT),]
}else{
  data <- data
}

dim(data)
# #Debugging the binomial testing
# for (cond in unique(data$EXPERIMENT))
# {
#   for (trial in unique(data$TRIAL))
#   {
#     n = length(data[data$EXPERIMENT == cond & data$TRIAL == trial,]$pathEXT)
#     x = sum(data[data$EXPERIMENT == cond & data$TRIAL == trial,]$pathEXT, na.rm=TRUE)
#     test = prop.test(x, n, conf.level=0.95)
#     #plotData$intLower[plotData$cond == cond & plotData$verb == trial] = test$conf.int[1]
#     #plotData$intUpper[plotData$cond == cond & plotData$verb == trial]  = test$conf.int[2]
#     print('set')
#     print(x)
#     print(n)
#     print(test$conf.int[1])
#     print(test$conf.int[2])
#   }
# }

#Rename conds for prettiness
if (!doExtension) {
  data$xEXPERIMENT[data$EXPERIMENT == 'MannerOfMotionCondition'] <- "Manner"
  data$xEXPERIMENT[data$EXPERIMENT == 'PathCondition'] <- "Path"
  data$EXPERIMENT <- data$xEXPERIMENT
}


makePlot = function(ydata, ylab, title="")
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
      #print(test$conf.int[1])
      #print(test$conf.int[2])
      #print(n)
      #print(x)
      }
    }
    print(plotData)
    #make a plot with ggplot
    pd <- position_dodge(0.1)
    
    ggplot(plotData, aes(x=verb, y=pathmean, colour=cond, group=cond, ymax = 1)) + 
      geom_errorbar(aes(ymin=intLower, ymax=intUpper), colour="black", width=.1, position=pd) +
      geom_line(position=pd) +
      ylab(ylab) +
      geom_point(position=pd, size=3) +
      coord_cartesian(ylim=c(0,1)) +
      ggtitle(title)
      #scale_colour_manual(values = c("green","red"),
                          #name="",
                          #labels=c("Manner", "Path")) +
}

makePlot(data$pathTEST, "Proportion of Effect Responses", "Responses after training")
makePlot(data$pathBIAS, 'Proportion of EFFECT responses', 'Bias (1st presentation) responses')
makePlot(data$pathEXT, 'Proportion of PATH responses', 'Bias responses - new domain')

#Now let's make some bar graphs too!
makeBar = function(ydata, ylab, title="")
{
  plotData = NULL
  #Aggregate mean/condition
  plotData = aggregate(x = list(pathmean = ydata), by = list( cond = data$EXPERIMENT), FUN = mean)
  #get the binomial conf.intervals per condition per trial
  for (cond in unique(data$EXPERIMENT))
  {
    n = length(ydata[data$EXPERIMENT == cond])
    x = sum(ydata[data$EXPERIMENT == cond])
    test = prop.test(x, n, conf.level=0.95)
    
    plotData$intLower[plotData$cond == cond] = test$conf.int[1]
    plotData$intUpper[plotData$cond == cond] = test$conf.int[2]
    
    
  }
  print(plotData)
  ggplot(plotData, aes(x=cond, y=pathmean, fill=cond)) + 
    geom_bar(stat="identity") +
    geom_errorbar(aes(ymin=intLower, ymax=intUpper), colour="black", width=.1) +
    coord_cartesian(ylim=c(0,1))+
    ylab(ylab)+
    ggtitle(title)
}

makeBar(data$pathTEST, 'Proportion of PATH responses', 'Responses after training')
makeBar(data$pathBIAS, 'Proportion of PATH responses', 'Bias (1st presentation) responses')
makeBar(data$pathEXT, 'Proportion of PATH responses', 'Bias responses - new domain')


#Now let's do some stats!


#How many participants are in this set?
length(unique(data$SUBNUM))
library(lme4)
model_eff <- NULL
model_noeff <- NULL
#Simplest model: Does EXPERIMENT matter?
model_eff <- lmer(pathBIAS ~ EXPERIMENT  + (1|SUBNUM), data=data, family="binomial")
model_noeff <- lmer(pathBIAS ~ 1  + (1|SUBNUM), data=data, family="binomial")
anova(model_eff, model_noeff)

model_eff <- lmer(pathEXT ~ EXPERIMENT  + (1|SUBNUM), data=data, family="binomial")
model_noeff <- lmer(pathEXT ~ 1  + (1|SUBNUM), data=data, family="binomial")
anova(model_eff, model_noeff)

#Do exp and trial interact? That is, is the different between exp different later in the exp? Do they diverge? Yes!

model_inter <- NULL
model_nointer <- NULL
model_tonly <- NULL
model_inter <- lmer(pathBIAS ~ EXPERIMENT*TRIAL  + (1|SUBNUM), data=data, family="binomial")
model_nointer <- lmer(pathBIAS ~ EXPERIMENT + TRIAL  + (1|SUBNUM), data=data, family="binomial")
#And considering just the experiment assignment & not time, is there a main effect of experiment? Yes
model_tonly <- lmer(pathBIAS ~ TRIAL  + (1|SUBNUM), data=data, family="binomial")

anova(model_inter, model_nointer)
anova(model_nointer, model_tonly)

anova(model_inter, model_tonly)
