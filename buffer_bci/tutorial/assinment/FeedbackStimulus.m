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

alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
interTargetDuration=1;
targetPresentation=2;
interCharDuration=0.1;

clf;
set(gcf,'color',[0 0 0],'toolbar','none','menubar','none'); % black figure
set(gca,'visible','off','color',[0 0 0]); % black axes
h=text(.5,.5,'text','HorizontalAlignment','center','VerticalAlignment','middle',...
       'FontUnits','normalized','fontsize',.2,'color',[1 1 1],'visible','off');

% play the stimulus
sendEvent('stimulus.feature_attention','start');



for target=1:10
    set(h,'string','Think of your target letter and get ready.','fontsize',.05,'visible','on','color',[1 1 1]);drawnow;
    sleepSec(targetPresentation);

    sendEvent('stimulus.clear_screen','start');
    set(h,'visible','off');drawnow;
    sleepSec(interTargetDuration);
    sendEvent('stimulus.clear_screen','end');

    sendEvent('stimulus.flash','start');
    for repetition=1:5
        for character_flash = randperm(26)
%             sendEvent('stimulus.testChar',character_flash);
            set(h,'string',alphabet(character_flash),'visible','on','fontsize',.2,'color',[1 1 1]);drawnow;
            sleepSec(interCharDuration);
        end;
    end;
    sendEvent('stimulus.flash','end');

    sendEvent('stimulus.clear_screen','start');
    set(h,'visible','off');drawnow;
    sleepSec(interTargetDuration);
    [devents,state]=buffer_newevents(buffhost,buffport,state,'classifier.prediction',[],500);
    [argvalue, argmax] = max(devents(1).value); %Find the class with the highest probability

    sendEvent('stimulus.clear_screen','end');
    set(h,'string',alphabet(argmax),'fontsize',.1,'visible','on','fontsize',.2,'color',[0 0 1]);drawnow;
    sleepSec(targetPresentation);
end;

sendEvent('stimulus.feature_attention','end');
msg=msgbox({'Thanks for taking part!'},'Continue?');while ishandle(msg); pause(.2); end;


