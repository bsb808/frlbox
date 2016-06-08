function fname = fname_t(varargin)

% fname = fname_t(prestr,poststr)
% 
% convenience function for making a file name with a timestamp, a prefix
% and as many suffix as you need
%
% >> fname_t('a','b','c')
% ans =
% a_20050817T121941_b_c
%
% bbing 17.08.05 for fun

if nargin == 0
    fname = datestr(now,30);
    return;
end

if isempty(varargin{1})
    fname = sprintf('%s',datestr(now,30));
else
    fname = sprintf('%s_%s',varargin{1},datestr(now,30));
end

for ii = 2:nargin
    fname = sprintf('%s_%s',fname,varargin{ii});
end

    
