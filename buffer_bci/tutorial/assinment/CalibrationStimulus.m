try; cd(fileparts(mfilename('fullpath')));catch; end;
try;
   run ../../matlab/utilities/initPaths.m
catch
   msgbox({'Please change to the directory where this file is saved before running the rest of this code'},'Change directory'); 
end

buffhost='localhost';buffport=1972;
% wait for the buffer to return valid header information
hdr=[];
while ( isempty(hdr) || ~isstruct(hdr) || (hdr.nchans==0) ) % wait for the buffer to contain valid data
  try 
    hdr=buffer('get_hdr',[],buffhost,buffport); 
  catch
    hdr=[];
    fprintf('Invalid header info... waiting.\n');
  end;
  pause(1);
end;

% set the real-time-clock to use
initgetwTime;
initsleepSec;

% make the target sequence
alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ';


interTargetDuration=1;
targetPresentation=2;
interCharDuration=0.1;
% make the stimulus
clf;
set(gcf,'color',[0 0 0],'toolbar','none','menubar','none'); % black figure
set(gca,'visible','off','color',[0 0 0]); % black axes
h=text(.5,.5,'text','HorizontalAlignment','center','VerticalAlignment','middle',...
       'FontUnits','normalized','fontsize',.2,'color',[1 1 1],'visible','off');

% play the stimulus
sendEvent('stimulus.feature_attention','start');



for target=1:10
    target_char_index = randi(26);
    target_char = alphabet(target_char_index);
    % reset the cue and fixation point to indicate trial has finished
    set(h,'visible','off');
    drawnow;
    sendEvent('stimulus.target_presentation','start');
    set(h,'string',target_char,'visible','on','color',[0 1 0]);drawnow;
    sleepSec(targetPresentation);
    sendEvent('stimulus.target_presentation','end');

    sendEvent('stimulus.clear_screen','start');
    set(h,'visible','off');drawnow;
    sleepSec(interTargetDuration);
    sendEvent('stimulus.clear_screen','end');

    sendEvent('stimulus.flash','start');
    for repetition=1:5
        for character_flash = randperm(26)
            sendEvent('stimulus.tgtFlash',character_flash); % indicate if it was a 'target' flash
            set(h,'string',alphabet(character_flash),'visible','on','color',[1 1 1]);drawnow;
            sleepSec(interCharDuration);
        end;
    end;
    sendEvent('stimulus.flash','end');

    sendEvent('stimulus.clear_screen','start');
    set(h,'visible','off');drawnow;
    sleepSec(interTargetDuration);
    sendEvent('stimulus.clear_screen','end');
end;

sendEvent('stimulus.feature_attention','end');
msg=msgbox({'Thanks for taking part!'},'Continue?');while ishandle(msg); pause(.2); end;


