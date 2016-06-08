function [label,dnum,datastr] = parseGumLogString(str)

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
% Example String
% str = '1970/01/01 00:02:02.08 ttyS2 $GPGGA,030333,4217.5919,N,07115.8383,W,1,06,1.7,52.6,M,-33.1,M,,*4B'


% for debugging
%str ='LBL	04/11/01 12:01:53.50 	LBL	II,  9.0, DT, 306120141; RR,   7.5, B, 02.4400; RR,   7.5, B, 06.0195; RR,   7.5, B, 06.1667; RR,   7.5, B, 06.5446; RR,   7.5, B, 09.6035; RR,   8.0, A, 01.4824; RR,   8.0, A, 01.5981; RR,   8.0, A, 01.7142; RR,   8.0, A, 01.8870; RR,   8.0, A, 02.0030; RR,   8.0, A, 02.1811; RR,   8.0, A, 02.4158; RR,   8.0, A, 05.5747; RR,   8.0, A, 05.6902; RR,   8.0, A, 05.8064; RR,   8.0, A, 05.9545; RR,   8.0, A, 06.0717; RR,   8.0, A, 06.2641; RR,   8.0, A, 06.3878; RR,   8.0, A, 06.9406; RR,   8.0, A, 09.6701; RR,   8.0, A, 09.7897; RR,   8.0, A, 09.9139; RR,  10.5, C, 03.8491; RR,  10.5, C, 04.9991; RR,  10.5, C, 07.0368; RR,  10.5, C, 07.1501; RR,  10.5, C, 07.2848; RR,  10.5, C, 08.2274; RR,  10.5, C, 08.4317; RR,  11.0, B, 02.4429; RR,  11.0, B, 06.0212; RR,  11.5, A, 01.4800; RR,  11.5, A, 05.5728; RR,  15.0, -, 00.0108'

% initialize
label = -1;
dnum = [];
datastr = '';

% First do the common parts of any dsl data format  Label, Date, Time, and
% Vehicle
%[label,remm] = strtok(str);
[dstr,remm] = strtok(str);
[tstr,remm] = strtok(remm);
[label,datastr] = strtok(remm);

% verification
if ( isempty(dstr) || isempty(tstr) || isempty(label) || isempty(datastr))
    fprintf('Error processing string - %s \n',str);
    label = -1;
    return;
end

% read the dsl time string and convert to matlab time
dnum = t_dsl2mat(tstr,dstr);

return

