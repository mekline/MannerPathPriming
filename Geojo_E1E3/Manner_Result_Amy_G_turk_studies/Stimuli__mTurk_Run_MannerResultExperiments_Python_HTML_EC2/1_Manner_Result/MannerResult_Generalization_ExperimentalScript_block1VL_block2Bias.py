import random
from willow.willow import *


def session(me):

   # AWS = "http://ec2-54-200-218-129.us-west-2.compute.amazonaws.com:8999/"
    newAWS = "54-201-146-153"
    AWS = "http://ec2-" + newAWS + ".us-west-2.compute.amazonaws.com:8999/"
        #server = amyamazonlarge; path: amyamazonlarge:~/videos
    
    def sentence(webPage, field, button = "SentenceButton"):  #field example: ambig[i] 
        let("")
        sentence = open(webPage).read()
        add(sentence.replace("ZZZ", field))

        background(ping, 2)
        take({"tag" : "click", "id": button, "client": me})
#        take({"tag": "ZING", "client": me})

    def video(webPage, field, sentence, delay):  #delay for Motion videos = 7 not 5 b/c these are longer than Means-Effect ones, 
        let("")
        videocode = open(webPage, "r").read()
 #       print videocode
        videocode = videocode.replace("XXX", field)
        videocode = videocode.replace("ZZZ", sentence)  #and videocode.replace("ZZZ", sentence))
        add(videocode)
        background(zing, float(delay) + 1.5)
        take({"tag": "ZING", "client": me})

    def testVideo(webPage, field, sentence):
        let("")
        testScreen = open(webPage, 'r').read()
        testScreen = testScreen.replace("XXX", field)
        testScreen = testScreen.replace("ZZZ", sentence)
        add(testScreen)

    def ping():
        put({"tag": "PING", "client" : me})
        
    def zing():
        put({"tag": "ZING", "client" : me})

    def seeVideoEnd():
        add(open('sawVidEnd.html'))
        msg = take({"tag":"click", "client":me})
        sawEnd = msg["id"]
        if sawEnd == "Yes":
            return 1
        return 0    

    def test(video, itemRESP):
        testVideo("CR_video_Test.html", AWS + video,\
                  "Does this show " + verbName[i] + "?")                      
        complete = 0
 #       bias1RESP.append(None)
        while not complete: #This is the annoying part!  As radio button clicks come in, Take them off the dictionary so you're always saving the last click.  When you exit, the last click is your response! There may well be a cleaner way to handle this....           
            #If we don't have  a response, get one
            if itemRESP == None:                                    
                itemRESP = take({"tag":"click", "client":me,"id":"yes"},
                        {"tag":"click", "client":me,"id":"no"}, {"tag": "click", "client" : me, "id": "error"})["id"]
                    #   {"tag":"click", "client":me,"id":"Neither"})["id"] 
            else:#If we have a response, wait for a new radio button OR a go-on signal
                sig = take({"tag":"click", "client":me,"id":"TestButton"},
                        {"tag":"click", "client":me,"id":"yes"},
                        {"tag":"click", "client":me,"id":"no"},{"tag": "click", "client": me, "id": "error"})["id"]
                        #{"tag":"click", "client":me,"id":"Neither"})["id"]                
                if sig=="yes" or sig=="no" or sig == "error":
                    itemRESP = sig
                else: #we got a go click!
                    print "item response = " + str(itemRESP)
                    complete = 1

                if itemRESP == "yes":
                    return 1
                elif itemRESP == "no": 
                    return 0
                else:
                    return -1
                
    def pause():
        #Little pause before going on
        background(ping,0.5)
        take({"tag":"PING", "client": me})
        let("")

    def testFeedback(video, itemRESP, correctRESP):
        if i + 1 < 5:
            attempts = 0
            feedback = 2
            while feedback >= 0:
                if int(itemRESP) == int(correctRESP):
                    if feedback == 2:
                        itemRESP = -1
                        attempts = 0
                    sentence('Verb_Sentence.html', "Good Job!") 
                    break
                elif feedback == 0:
                    sentence('Verb_Sentence.html', "Sorry! You are out of chances :(")
 #                   attempts = 3
                    break
                elif int(itemRESP) != int(correctRESP):              
                    sentence('Verb_Sentence.html', "Sorry! You have " + str(feedback) + " chances to try again!")
                    itemRESP = test(video, itemRESP)
                    feedback -= 1
                    attempts += 1
        else:
            itemRESP = -1
            attempts = -1
        return itemRESP, attempts
        
### END HELPER FUNCTIONS ###
                
    x = random.randint(0, 16777215000)
    payCode = "%x" % x
    payCode = random.choice('abcdefghij') + payCode + random.choice('abcdefghij')
    payCode += str(me)

    meansFile = open('MeansCondition.csv', 'U').readlines()[1:]
    effectFile = open('EffectCondition.csv', 'U').readlines()[1:]

    mannerOfMotionFile = open('MannerOfMotionCondition_DOsentences.csv', 'U').readlines()[1:]
    pathFile = open('PathCondition_DOsentences.csv', 'U').readlines()[1:]

 
#conditions = 1) teach manner or path verbs/induce bias --> compare effect on CoS events | VL & extension with means or effect verbs --> see if bias is different for motion verbs depending on bias induced via verb learning
 
    conditions = [1, 2]
 #   chosenCondition = 1           #trying to see if DO sentences leads to transfer from causal to motion
    chosenCondition = random.choice(conditions)
 
 
    if chosenCondition == 1:
        eventOrder = "b1Motion_b2Causal"                      
        if random.choice([1, 2]) == 1:
            blockOrder = "b1MannerOfMotion_b2Causal"  #block 1 = VL & extension; learn mannerOfMotion verbs; block 2 assess bias for CoS events
            primeItems = mannerOfMotionFile     #Verb learning & extension paradigm
            testItems = meansFile      #note since this just tests bias for causal events; means file is the same as the effect file
        else:
            blockOrder = "b1Path_b2Causal"  #B1 VL-path verbs; B2- assess bias for CoS events
            primeItems = pathFile          #learn path verbs    
            testItems = meansFile          #bias for CoS events
            
    elif chosenCondition == 2:
        eventOrder = "b1Causal_b2Motion"
        if random.choice([1, 2]) == 1:
            blockOrder = "b1Means_b2Motion"
            primeItems = meansFile    
            testItems = mannerOfMotionFile  #mannerOfMotionFile == pathFile since only ambig & bias blocks are seen in B2
        else:
            blockOrder = "b1Effect_b2Motion"
            primeItems = effectFile           
            testItems = mannerOfMotionFile

 
            
    random.shuffle(primeItems)
    random.shuffle(testItems)

    items = primeItems + testItems
      
    itemId = []
    eventType = []
    condition = []
    manner = []
    result = []
    verbName = []
    verbMeaning = []
    ambigS = []
    ambigV = []
    biasV1 = []
    biasV1Ans = []
    biasV2 = []
    biasV2Ans = []
    trainS1 = []
    trainV1 = []
    trainS2 = []
    trainV2 = []
    trainS3 = []
    trainV3 = []
    testV1 = []
    testV1Ans = []
    testV2 = []
    testV2Ans = []
    videoLength = []

    itemIdCol = 0
    eventTypeCol = 1
    conditionCol = 2
    mannerCol = 3
    resultCol = 4
    verbNameCol = 5  
    verbMeaningCol = 6
    ambigSCol = 7  
    ambigVCol = 8
    biasV1Col = 9
    biasV1AnsCol = 10 
    biasV2Col = 11
    biasV2AnsCol = 12
    trainS1Col = 13
    trainV1Col = 14
    trainS2Col = 15
    trainV2Col = 16
    trainS3Col = 17
    trainV3Col = 18
    testV1Col = 19
    testV1AnsCol = 20
    testV2Col = 21
    testV2AnsCol = 22
    videoLengthCol = 23
    
    for i in xrange(len(items)):
        fields = items[i].strip().split(',')
        itemId.append(fields[itemIdCol])
        eventType.append(fields[eventTypeCol])
        condition.append(fields[conditionCol])
        manner.append(fields[mannerCol])
        result.append(fields[resultCol])
        verbName.append(fields[verbNameCol])
        verbMeaning.append(fields[verbMeaningCol])
        ambigS.append(fields[ambigSCol])
        ambigV.append(fields[ambigVCol])
        biasV1.append(fields[biasV1Col])
        biasV1Ans.append(fields[biasV1AnsCol])
        biasV2.append(fields[biasV2Col])
        biasV2Ans.append(fields[biasV2AnsCol])
        trainS1.append(fields[trainS1Col])
        trainV1.append(fields[trainV1Col])
        trainS2.append(fields[trainS2Col])
        trainV2.append(fields[trainV2Col])
        trainS3.append(fields[trainS3Col])
        trainV3.append(fields[trainV3Col])
        testV1.append(fields[testV1Col])
        testV1Ans.append(fields[testV1AnsCol])
        testV2.append(fields[testV2Col])
        testV2Ans.append(fields[testV2AnsCol])
        videoLength.append(fields[videoLengthCol])

    #header for variables included in data
    log('WillowSubNo', 'PayCode', 'movieCheck', 'trialNo', 'itemId', 'eventOrder', 'blockOrder', 'eventType', 'condition',\
        'manner', 'result','verbName','verbMeaning', 'seeAmbigV1', 'seeAmbigV2', 'seeBiasV1', 'seeBiasV2',\
        'seeTrain1a', 'seeTrain2a', 'seeTrain3a', 'seeTrain1b', 'seeTrain2b', 'seeTrain3b', 'seeTestV1',\
        'seeTestV2','ambigS', 'ambigV', 'bias1', 'bias2', 'biasV1Ans', 'bias1RESP', 'biasV2Ans','bias2RESP',\
        'test1', 'test2', 'testV1Ans', 'test1RESP', 'testV2Ans', 'test2RESP', 'catchTrialNum', 'catchOrderedNum', 'catchTrialRESP', 'commentCheck')
    

    #consent
    add(open("consent_MannerResultVerbs.html"))
    take({"tag":"click", "id": "ConsentButton", "client": me})
    let("")
    

##    #system requirements screen
    add(open("requirements.html"))
    take({"tag": "click", "id": "ReqButton", "client": me})
    let("")

##    #Test movie
    let("")
    add(open("empty.html"))
    videocode = open("Movie_Check_Video.html", "r").read()
    videocode = videocode.replace("XXX",  AWS + "MovieVisibleCheck")  #AWS - variable for amazon server IP address
    videocode = videocode.replace("ZZZ", "Can you see this video?")
    add(videocode)
 #   add("<h> Can you see this video? </h>")

    background(ping, 5)
    take({"tag": "PING", "client": me})
    let("")
    #... add question
    add(open("moviecheck.html"))
    msg = take({"tag": "click", "client": me})
 #   print msg

    #kick them off if they didn't see it!
    if msg["id"] == "No":
        let("")
        add(open("sorry.html"))
    #Otherwise make them describe!
    else:
        let("")
        add(open("moviecheck2.html"))

    take({"tag": "click", "id": "GoButton", "client": me})
    
    #Find out if they saw and reported the video
    movieCheck = peek("#MovieDescrip")
    #print(movieCheck)
    let("")

    #instructions screen
    add(open('Instructions_MannerResult_Priming.html'))
    take({"tag": "click", "id": "InstructButton", "client": me})
    let("")

    bias1RESP = []
    bias2RESP = []
    test1RESP = []
    test2RESP = []

    seeTrain1a = []
    seeTrain2a = []
    seeTrain3a = []
    
    seeTrain1b = []
    seeTrain2b = []
    seeTrain3b = []

    seeTestV1 = []
    seeTestV2 = []

    testV1RESP = []
    testV2RESP = []
    


    for i in xrange(len(items)):
        bias1RESP.append(None)
        bias2RESP.append(None)
        test1RESP.append(None)
        test2RESP.append(None)

        seeTrain1a.append(None)
        seeTrain2a.append(None)
        seeTrain3a.append(None)

        seeTrain1b.append(None)
        seeTrain2b.append(None)
        seeTrain3b.append(None)
        
        seeTestV1.append(None)
        seeTestV2.append(None)

        testV1RESP.append(None)
        testV2RESP.append(None)
        


    for i in xrange(len(items)):
        
        sentence('Verb_Sentence_2.html', "Verb " + str(i + 1) + " of " + str(len(items)))

        #Now Learn 
        sentence('Verb_Sentence_2.html', "Now learn: " + verbName[i])
        let("")
        
        #ambigS
        sentence('Verb_Sentence.html', ambigS[i]) #ambigS
        let("")
        
        #ambigV        
        video("CR_video.html", AWS + ambigV[i], ambigS[i], videoLength[i])
        let("")
        seeAmbigV1 = seeVideoEnd()
        #ambigV (repeat)
        sentence('Verb_Sentence_2.html', "Let's see that again!")
        let("")
        video("CR_video.html", AWS + ambigV[i], ambigS[i], videoLength[i])
        let("")
        seeAmbigV2 = seeVideoEnd()

        #PreBias
        sentence('Pre_Test.html', verbName[i], button = "PreTestButton")  #pre-bias S
        let("")

        #Bias1 Video        
        video("CR_video.html", AWS + biasV1[i],\
              "Watch to see if this shows " + verbName[i] + "?", videoLength[i])
        let("")
        seeBiasV1 = seeVideoEnd()
        let("")
        bias1RESP[i] = test(biasV1[i], bias1RESP[i])     #play bias video 2x & record response 'does this show verb-ing'
    
        #Little pause before going on
        pause()

        #Bias 2 Video
        video("CR_video.html", AWS + biasV2[i],\
              "Watch to see if this shows " + verbName[i] + "?", videoLength[i])
        let("")
        seeBiasV2 = seeVideoEnd()
        let("")
        bias2RESP[i] = test(biasV2[i], bias2RESP[i])
                   
        #Little pause before going on
        pause()

        if i < len(primeItems):

            #pre-Training
            sentence('Pre_Training.html', verbName[i], button = "PreTestButton") 

            #trainS1
            sentence('Verb_Sentence.html', trainS1[i])
            
            #trainV1
            video("CR_video.html", AWS + trainV1[i], trainS1[i], videoLength[i])
            let("")
            seeTrain1a = seeVideoEnd()
            let("")
            sentence('Verb_Sentence_2.html', "Let's see that again!")
            let("")
            video("CR_video.html", AWS + trainV1[i], trainS1[i], videoLength[i])
            let("")
            seeTrain1b = seeVideoEnd()

            #trainS2
            sentence('Verb_Sentence.html', trainS2[i])
            #trainV2
            video("CR_video.html", AWS + trainV2[i], trainS2[i], videoLength[i])
            let("")
            seeTrain2a = seeVideoEnd()
            let("")
            sentence('Verb_Sentence_2.html', "Let's see that again!")
            let("")
            video("CR_video.html", AWS + trainV2[i], trainS2[i], videoLength[i])
            let("")
            seeTrain2b = seeVideoEnd()

            #trainS3
            sentence('Verb_Sentence.html', trainS3[i])
            #trainV3
            video("CR_video.html", AWS + trainV3[i], trainS3[i], videoLength[i])
            let("")
            seeTrain3a = seeVideoEnd()
            let("")
            sentence('Verb_Sentence_2.html', "Let's see that again!")
            let("")
            video("CR_video.html", AWS + trainV3[i], trainS3[i], videoLength[i])
            let("")
            seeTrain3b = seeVideoEnd()

            #PreTest
            sentence('Pre_Test.html', verbName[i], button = "PreTestButton")  

            #test1V
            video("CR_video.html", AWS + testV1[i],\
                  "Watch to see if this shows " + verbName[i] + "?", videoLength[i])
            let("")
            seeTestV1 = seeVideoEnd()
            let("")
            test1RESP[i] = test(testV1[i], test1RESP[i])

            #Test2 Video
            video("CR_video.html", AWS + testV2[i],\
                  "Watch to see if this shows " + verbName[i] + "?", videoLength[i])
            let("")
            seeTestV2 = seeVideoEnd()
            let("")
            test2RESP[i] = test(testV2[i], test2RESP[i])

            #Little pause before going on
            pause()
 
        let("")

        add(open("comments.html"))
        take({"tag": "click", "id": "GoButton", "client": me})
        commentCheck = peek("#Comment")
        let("")
                                
        #catch Trial: order numbers
        catchTrialNum = ' '.join(str(int(random.random()*100000)))
        catchOrderedNum = ''.join(sorted(list(catchTrialNum)))
        add("<p> Order the numbers from smallest to biggest <b> %s </b>" % catchTrialNum)
        add("<input id='checkNum' type = 'text'>")
        add("<input id='go' type = 'submit'>")
        take({"tag":"click", "id":"go", "client":me})
        catchTrialRESP = str(peek("#checkNum")).replace(" ", "")
        let("")

        log(me, payCode, movieCheck, i + 1, itemId[i], eventOrder, blockOrder, eventType[i], condition[i], manner[i], result[i],\
            verbName[i], verbMeaning[i], seeAmbigV1, seeAmbigV2, seeBiasV1, seeBiasV2, seeTrain1a, seeTrain2a,\
            seeTrain3a, seeTrain1b, seeTrain2b, seeTrain3b, seeTestV1, seeTestV2, ambigS[i], ambigV[i],\
            biasV1[i], biasV2[i], biasV1Ans[i], bias1RESP[i], biasV2Ans[i], bias2RESP[i], testV1[i], testV2[i],\
            testV1Ans[i], test1RESP[i], testV2Ans[i], test2RESP[i], catchTrialNum, catchOrderedNum, catchTrialRESP, commentCheck)             


        #pause before going on
        background(ping, 0.5)
        take({"tag": "PING", "client" : me})
        
    #End Memory loop
        
    #Show thankyou and total score!
    let("")
    thanks = open("thankyou.html", "r").read()
    thanks = thanks.replace("YYY", payCode)

    add(thanks)
            
  

run(session)

#run(session, 8112)








