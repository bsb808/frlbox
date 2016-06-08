function ss = t_dsl2unix(dslTimeStr,dateS)

% sec_from_1970 = t_dsl2unix(dslTimeStr,dateS)
%
% Takes in a dsl format time string and returns a matlab time number
%
% retruns a dnum = -1 if there is a problem
%
% optional second argument to tell us the date
% we can send the dslTimeStr as the time (mm:hh:ss.sss) AND
% the date String as (yyyy/mm/dd)
% OR 
% send the whole thing as a big string
% yyyy/mm/dd mm:hh:ss.sss
%
if nargin == 1
    dnum = t_dsl2mat(dslTimeStr);
else
    dnum = t_dsl2mat(dslTimeStr,dateS);
end

ss= t_mat2unix(dnum);

return
%t1 = 719529;   % this is the date number for Jan 1 1970
%secs_from_1970=(dnum-t1)*24*3600;

