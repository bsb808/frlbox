function dslStr = t_mat2dsl(dnum)
% dslStr = t_mat2dsl(dnum)
%
% returns a formatted dsl time string
% yyyy/mm/dd mm:hh:ss.sss
% takes a matlabe dnum as input


% get thousands of a second
dayy = rem(dnum,1);
secs = dayy*24*60*60;
frac_secs = rem(secs,1);
sstr = sprintf('%5.3f',frac_secs);
dslStr = [datestr(dnum,26) ' ' datestr(dnum,13) sstr(2:end)];
