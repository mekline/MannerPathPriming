function [] = SetParameters()
%Sets all the default parameters for a TTW experiment!
%The types of parameters in this file are things that should never ever
%need to change.  If I find myself wanting to change for debugging or
%different versions, I take it out of here and add it to para.txt and make
%a corresponding ReadParaFile line

global parameters; %(Remember this gets declared at the start of every function!)

%%%%%%%%%%%
% Set up screen and standard size/color parameters
%%%%%%%%%%%

%Screen default parameters that the calibrator/tobii uses- should be 
%constant for any experiment

scr.screens = Screen('Screens');
scr.displayScreen = max(scr.screens);
scr.black = BlackIndex(scr.displayScreen);
scr.white = WhiteIndex(scr.displayScreen);
scr.gray = GrayIndex(scr.displayScreen);
scr.bgcolor = [scr.black scr.black scr.black];
scr.rect = Screen('Rect', scr.displayScreen);
scr.res = scr.rect(3:4);
scr.numberOfBuffers = 2; %doublebuffer
scr.winPtr = [];       
[scr.winPtr, scr.winRect] = Screen('OpenWindow', scr.displayScreen);
parameters.scr = scr;


% Set priority for script execution to realtime priority.
% This ensures that we can run the experiment with minimal 
% interference from other computer operations.
priorityLevel=MaxPriority(parameters.scr.winPtr);
Priority(priorityLevel);

%Set keyboard stuff - Macs seem to prefer if you also declare these in the
%main function for some reason.  Whatever, just do it :p
KbName('UnifyKeyNames');
parameters.space=KbName('space');
parameters.esc=KbName('ESCAPE');
parameters.z_press=KbName('z');
parameters.c_press=KbName('c');
parameters.q_press=KbName('q');
parameters.x_press=KbName('x');
parameters.r_press=KbName('r');
parameters.space2=KbName('SPACE');
parameters.w_press=KbName('w');
parameters.p_press=KbName('p');
    
RestrictKeysForKbCheck([parameters.space parameters.z_press parameters.c_press parameters.space2 parameters.p_press parameters.w_press]);
% Set text size
Screen('TextSize', parameters.scr.winPtr, 14);

%for responses and trial parameters!
parameters.response = [];

%%%%%%%%%%%
% Set video rectangle parameters
% Note: this is all relativized to monitor size
%%%%%%%%%%%

winlength = parameters.scr.winRect(3);
winheight = parameters.scr.winRect(4);

border = 30;
moviewidth = winlength/2 - 2*(border);
movieheight = moviewidth * (3/4);


topheight = (winheight-movieheight)/3;
leftcorner = border-5;
rightcorner = winlength/2 + border;
parameters.leftbox = [leftcorner,topheight,leftcorner+moviewidth,topheight+movieheight];
parameters.rightbox = [rightcorner,topheight,rightcorner+moviewidth,topheight+movieheight];
centercorner = (winlength/2)-(moviewidth/2);
parameters.centerbox = [centercorner, topheight, centercorner+moviewidth, topheight + movieheight];

%%%%%%%%%%%
% Set Tobii parameters (or ignore in behavioral experiments
%%%%%%%%%%%

parameters.ConnTobii = 0; %Are we trying to connect to the Tobii right now?
parameters.EYETRACKER = 0; %Are we actually connected?

%Tobii connection parameters for ECCL/BCM eyetracker
parameters.hostName = '169.254.6.227';
parameters.portName = '4455';

%%%%%%%%%%%
% Set any other parameters
%%%%%%%%%%%

%Set any parameters here that will be constant in your experiment.  With
%very slightly more effort you might want to set them in a para.txt file &
%add lines to ReadParaFile instead, to make them easier to modify.  





end

