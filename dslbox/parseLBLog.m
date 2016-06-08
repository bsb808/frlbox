function [dnum,tx,rx] = parseLBLog(str)

% parsing an LBL data string from the 455
%
% OUTPUT
% returns dnum = -1 if there is an error
%
% HISTORY
% 01.11.04  bbing  Created - TAG '04

% for debugging
%str ='LBL	04/11/01 12:01:53.50 	LBL	II,  9.0, DT, 306120141; RR,   7.5, B, 02.4400; RR,   7.5, B, 06.0195; RR,   7.5, B, 06.1667; RR,   7.5, B, 06.5446; RR,   7.5, B, 09.6035; RR,   8.0, A, 01.4824; RR,   8.0, A, 01.5981; RR,   8.0, A, 01.7142; RR,   8.0, A, 01.8870; RR,   8.0, A, 02.0030; RR,   8.0, A, 02.1811; RR,   8.0, A, 02.4158; RR,   8.0, A, 05.5747; RR,   8.0, A, 05.6902; RR,   8.0, A, 05.8064; RR,   8.0, A, 05.9545; RR,   8.0, A, 06.0717; RR,   8.0, A, 06.2641; RR,   8.0, A, 06.3878; RR,   8.0, A, 06.9406; RR,   8.0, A, 09.6701; RR,   8.0, A, 09.7897; RR,   8.0, A, 09.9139; RR,  10.5, C, 03.8491; RR,  10.5, C, 04.9991; RR,  10.5, C, 07.0368; RR,  10.5, C, 07.1501; RR,  10.5, C, 07.2848; RR,  10.5, C, 08.2274; RR,  10.5, C, 08.4317; RR,  11.0, B, 02.4429; RR,  11.0, B, 06.0212; RR,  11.5, A, 01.4800; RR,  11.5, A, 05.5728; RR,  15.0, -, 00.0108'

% initial ize
dnum = [];
tx = [];
rx = [];

% generic parser - strips the label and date out of the record
[label,dnum,dstr]=parseDSLog(str);

if label == -1
    dnum = -1;
    return;
end

% now work on the actual data

% first get the second label

[label2,remm]=strtok(dstr);

%  clear tx rx;
% tx = [];
% rx = [];


cnt = 0;
strCell = {};
while ~isempty(remm)
    [sBlock,remm] = strtok(remm,';');
    
    % now parse each cell
    [IR,crem] = strtok(sBlock,',');
    if ~isempty(strfind(IR,'II'))
        % interrogate
        [slotStr,cremm] = strtok(crem,',');
        tx.slot = sscanf(slotStr,'%f');
        
    elseif ~isempty(strfind(IR,'RR'))
        % response
        [slotStr,cremm] = strtok(crem,',');
        [labelStr,cremm] = strtok(cremm,',');
        [ttStr,cremm] = strtok(cremm,',');
        
        % convert 
        slotNum = sscanf(slotStr,'%f');
        ttNum = sscanf(ttStr,'%f');
        labelChar = sscanf(labelStr,'%1s',1);
        
        % is this a new one?  assume they are reported in ascending order?
        if (cnt==0 || rx.slot(cnt) ~= slotNum)
            cnt = cnt+1;
            rx.slot(cnt) = slotNum;
            rx.label{cnt} = labelChar;
            rx.tt{cnt} = ttNum;
            
        elseif ( rx.slot(cnt) == slotNum )
            rx.tt{cnt} = [rx.tt{cnt} ttNum];
        end
    else
        % don't recognize this !
        
    end
    
end

if (isempty(dnum) || isempty(tx) || isempty(rx))
    dnum = -1;
    tx = [];
    rx = [];
end

