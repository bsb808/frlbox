function secs_from_1970 = t_mat2unix(days_00)

% secs_from_1970 = datenum2tunix(days_00)
%
% Convert from matlab datenum's to unix seconds
% Matlab uses datenum - days since 2000
% Unix uses seconds since 1970
%
% bbing
%
% 

t1=719529;   % this is the date number for Jan 1 1970
secs_from_1970 = (days_00 - t1) * (24*3600);
