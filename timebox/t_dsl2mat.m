function dnum = t_dsl2mat(dslTimeStr,dslDateStr)

% dnum = t_dsl2mat(dslTimeStr,dslDateStr)
%
% Takes in a dsl format time string and returns a matlab time number
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

if nargin < 2
    % split the string into a date and time part
    [dslDateStr,rem] = strtok(dslTimeStr); % this gets the date string off the front
    dslTimeStr = rem(2:end);
end

if length(dslDateStr) == 8
   [dV,dcount] = sscanf(dslDateStr,'%2d/%2d/%2d');
   dV(1)=2000+dV(1);  %two character year
elseif length(dslDateStr) == 10
   [dV,dcount] = sscanf(dslDateStr,'%4d/%2d/%2d');
else
   fprintf('Date string (%s) is length %d, not the right length = 8 OR 10\n',dslDateStr,length(dslDateStr));
    dnum = -1;
    return;
 end
 

% This parses the time part of the string (mm:hh:ss.sss)
% pad w/ whitespace

if length(dslTimeStr) <= 12
    while length(dslTimeStr) < 12
        dslTimeStr = [dslTimeStr ' '];
    end
end

if length(dslTimeStr) < 12
    fprintf('Time string (%s) is length (%d), not the right length (12 characters)\n',...
        dslTimeStr,length(dslTimeStr));
    dnum = -1;
    return
end

[tV,tcount] = sscanf(dslTimeStr,'%2d:%2d:%f');

if (dcount~=3) | tcount~=3
    fprintf('Wrong number of field counts\n')
    dnum = 1;
    return;
end

dnum = datenum(dV(1),dV(2),dV(3),tV(1),tV(2),tV(3));


