function dsl_fname = dnum2dslfname(dnum)

% Converts matlab date numbers (dnum) to a filename (dsl_fname)
% without an extention
%
% bbing 29.07.03
%

mm = datestr(dnum,5);
dd = datestr(dnum,7);
yy = datestr(dnum,11);

ll = datestr(dnum,30);
ll = ll(10:end);

dsl_fname = sprintf('%s%s%s_%s',yy,mm,dd,ll);

