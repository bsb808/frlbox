function dnum = t_acg2mat(acgDateTimeStr)

% dnum = t_acg2mat(acgDateTimeStr)
%
% Takes in a acoistic communications group (ACG) format 
% time string and returns a matlab time number
%
% returns a dnum = -1 if there is a problem
%
% optional second argument to tell us the date
% we can send the dslTimeStr as the time (mm:hh:ss.sss) AND
% the date String as (yy/mm/dd OR yyyy/mm/dd)
% OR 
% send the whole thing as a big string
% yyyy/mm/dd mm:hh:ss.sss OR yy/mm/dd mm:hh:ss.sss
%
% 05.10.04  bbing  set up to handle 2 digit OR 4 digit year


if length(acgDateTimeStr) ~= 20
    fprintf('Date string (%s) is length %d, not the right length = 8 OR 10\n',dslDateStr,length(dslDateStr));
    dnum = -1;
    return;
 end
 

% This parses the time part of the string (mm:hh:ss.sss)
% pad w/ whitespace

[dstr,tstr]=strtok(acgDateTimeStr);

[dV,dcount] = sscanf(dstr,'%4d-%2d-%d');
[tV,tcount] = sscanf(tstr,'%2d:%2d:%2dZ');

if (dcount~=3) | tcount~=3
    fprintf('Wrong number of field counts\n')
    dnum = 1;
    return;
end

dnum = datenum(dV(1),dV(2),dV(3),tV(1),tV(2),tV(3));


