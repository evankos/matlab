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


verb=1;
cname='clsfr';
trlen_ms=5*2600;
clsfr=load(cname);if(isfield(clsfr,'clsfr'))clsfr=clsfr.clsfr;end;


% wait for new events of a particular type
state=[]; % initial state
endExpt=false; % until exit event is received
state=[];
endTest=0; fs=0;
while ( endTest==0 )
    % reset the sequence info
    endSeq=0;
    fs(:)=0;  % predictions
    nFlash=0; % number flashes processed


  [data,devents,state]=buffer_waitData(buffhost,buffport,state,'startSet',{'stimulus.flash' 'start'},'exitSet',{'stimulus.flash' 'end'},'trlen_ms',trlen_ms);

  % process these events
  for ei=1:numel(devents)
    if ( matchEvents(devents(ei),'stimulus.feature_attention','end') ) % end training
      fprintf('Got end feedback event\n');endTest=true;

    elseif ( matchEvents(devents(ei),'stimulus.flash','start') ) % flash, apply the classifier
      % apply classification pipeline to this events data
      [f,fraw,p]=buffer_apply_erp_clsfr(data(ei).buf,clsfr);
      sendEvent('classifier.prediction',f,devents(ei).sample);
      fprintf('Sent classifier prediction = %s.\n',sprintf('%g ',f));
    end
  end % devents
end % feedback phase


