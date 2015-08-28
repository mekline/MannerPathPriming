function [] = Text_Show(message, varargin);
%This puts some text up on the screen in a default size & location
global parameters

%Get current Text settings so we can use them as defaults

DefaultFont = Screen('TextFont',parameters.scr.winPtr);
DefaultSize = Screen('TextSize',parameters.scr.winPtr);
DefaultStyle = Screen('TextStyle', parameters.scr.winPtr);

%Check for additional parameters!
p = inputParser;
p.addRequired('message', @isstr);
p.addParamValue('color', parameters.scr.white, @(x) true);
p.addParamValue('start_x', floor(parameters.scr.winRect(3)*(5/12)), @(x) true);
p.addParamValue('start_y', floor(parameters.scr.winRect(4)/2), @(x) true);
p.addParamValue('bounding_characters', 60, @(x) true);
p.addParamValue('font', DefaultFont, @(x) true);
p.addParamValue('size', DefaultSize, @(x) true);
p.addParamValue('style', DefaultStyle, @(x) true);

p.parse(message, varargin{:});
inputs = p.Results;

%Update fonts and size, if any:
% Select specific text font, style and size:
Screen('TextFont',parameters.scr.winPtr, inputs.font);
Screen('TextSize',parameters.scr.winPtr, inputs.size);
Screen('TextStyle', parameters.scr.winPtr, inputs.style);

% Clear screen to background color
Screen('FillRect', parameters.scr.winPtr, parameters.scr.black);
% ...and flip it up. Initial display and sync to timestamp:
vbl=Screen('Flip', parameters.scr.winPtr);

%Display the message
DrawFormattedText(parameters.scr.winPtr, inputs.message, inputs.start_x, inputs.start_y, inputs.color, inputs.bounding_characters);

vbl=Screen('Flip', parameters.scr.winPtr);




