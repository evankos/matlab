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

% wait for new events of a particular type
state=[]; % initial state
endExpt=false; % until exit event is received

trlen_ms=5*2600;
dname  ='calibration_data';

% Grab 5*2600ms data after every stimulus.target event
[data,devents,state]=buffer_waitData(buffhost,buffport,[],'startSet',{'stimulus.tgtFlash'},'exitSet',{'stimulus.feature_attention' 'end'},'trlen_ms',trlen_ms);
mi=matchEvents(devents,'stimulus.feature_attention','end'); devents(mi)=[]; data(mi)=[]; % remove the exit event
fprintf('Saving %d epochs to : %s\n',numel(devents),dname);
save(dname,'data','devents');

