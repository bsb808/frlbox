function [label,dnum,datastr] = parseDSLog(str)

% Generic parser for DSL-type logged strings
% This function is meant to be used as the first step in parsing a DSL
% logged data string (ASCII)
%
% INPUT
% str - a string from dsl (jason) data logs
%
% OUTPUT
% label - the three character label (eg., LBL, JAS, OCT, etc.)
% dnum - the timestamp in matlab format
% datastr - the logged ascii data - watch out for leading white space!
%
% EXAMPLE
%
% 01.11.04  bbing  Created for reading LBL log files - TAG '04
%

% for debugging
%str ='LBL	04/11/01 12:01:53.50 	LBL	II,  9.0, DT, 306120141; RR,   7.5, B, 02.4400; RR,   7.5, B, 06.0195; RR,   7.5, B, 06.1667; RR,   7.5, B, 06.5446; RR,   7.5, B, 09.6035; RR,   8.0, A, 01.4824; RR,   8.0, A, 01.5981; RR,   8.0, A, 01.7142; RR,   8.0, A, 01.8870; RR,   8.0, A, 02.0030; RR,   8.0, A, 02.1811; RR,   8.0, A, 02.4158; RR,   8.0, A, 05.5747; RR,   8.0, A, 05.6902; RR,   8.0, A, 05.8064; RR,   8.0, A, 05.9545; RR,   8.0, A, 06.0717; RR,   8.0, A, 06.2641; RR,   8.0, A, 06.3878; RR,   8.0, A, 06.9406; RR,   8.0, A, 09.6701; RR,   8.0, A, 09.7897; RR,   8.0, A, 09.9139; RR,  10.5, C, 03.8491; RR,  10.5, C, 04.9991; RR,  10.5, C, 07.0368; RR,  10.5, C, 07.1501; RR,  10.5, C, 07.2848; RR,  10.5, C, 08.2274; RR,  10.5, C, 08.4317; RR,  11.0, B, 02.4429; RR,  11.0, B, 06.0212; RR,  11.5, A, 01.4800; RR,  11.5, A, 05.5728; RR,  15.0, -, 00.0108'

% initialize
label = -1;
dnum = [];
datastr = '';

% First do the common parts of any dsl data format  Label, Date, Time, and
% Vehicle
[label,remm] = strtok(str);
[dstr,remm] = strtok(remm);
[tstr,datastr] = strtok(remm);

% verification
if ( isempty(dstr) || isempty(tstr) || isempty(label) || isempty(datastr))
    fprintf('Error processing string - %s \n',str);
    lablel = -1;
    return;
end

% read the dsl time string and convert to matlab time
dnum = t_dsl2mat(tstr,dstr);

return

% Now do the labelformat user-defined parsing
[data.veh,dataStr] = strtok(dstr);  % get the string off the front
% concatenate the format string
if mod(length(labelformat),2)
   % not an even number of arguements!!!
end

formatStr = '';
for ii = 2:2:length(labelformat)
   formatStr = [formatStr ' ' labelformat{ii}];
end

retStr = '';
for ii = 1:2:length(labelformat)
   if ~strcmp(labelformat{ii},'skip')  % allow for skipping some elements
      retStr = [retStr 'data.' labelformat{ii} ', '];
   end
end

cmdstr = sprintf('[%s]=strread(dstr,''%s'');',retStr,formatStr);
eval(cmdstr);

return

% only scan the max. number of expected elements (because the spec. might
% be wrong!
% 
% NN = length(labelformat)/2;
% [aa,cnt] = sscanf(dataStr,formatStr,NN);
% 
% cc = 1;
% for ii = 1:2:length(labelformat)-1
%    data.(labelformat{ii})=aa(cc);
%    cc = cc+1;
% end



