function [] = Setup_PTool()
% Just encapsulates all the boilerplate that has to come at the
% beginning of any Psychtoolbox script.  All initialization,
% window size setting, color resolution and so on should happen right here

global parameters

%%%%%%%%%%%
% Opening boilerplate
%%%%%%%%%%%
% Clear Matlab/Octave window:
clc;

% check for Opengl compatibility, abort otherwise:
AssertOpenGL;


% Reseed the random-number generator for each expt.
rand('state',sum(100*clock));
%reset rand seed
rand('seed', GetSecs);

% Make sure keyboard mapping is the same on all supported operating systems
% Apple MacOS/X, MS-Windows and GNU/Linux.  Name the keys we will use
% in this experiment
KbName('UnifyKeyNames');

%Make PTB less verbose!
Screen('Preference', 'Verbosity', 0);
Screen('Preference', 'SkipSyncTests',1);
Screen('Preference', 'VisualDebugLevel',0);
PsychPortAudio('Verbosity',0);

% Do dummy calls to GetSecs, WaitSecs, KbCheck to make sure
% they are loaded and ready when we need them - without delays
% in the wrong moment:
KbCheck;
WaitSecs(0.1);
GetSecs;

HideCursor;

% Perform basic initialization of the sound driver:
InitializePsychSound;

end

