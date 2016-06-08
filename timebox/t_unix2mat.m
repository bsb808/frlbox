function days_00 = t_unix2mat(secs_from_1970) 
%
% Converts Unix time (seconds since Jan-01-1970) 
% to Matlab time (days since 1-Jan-0000)
% 
% Matlab datenum and datevec use year 0 as ref, but we will use Jan 1 1970 
% as ref to be compatible w/ unix convention.
% 
% 
%  August 1997 G. Lerner, cteated and written
%  Stolen by bbing
%

% t1 = datenum(1970,1,1);

t1=719529;   % this is the date number for Jan 1 1970
days_00 = secs_from_1970/(24*3600)+t1;

