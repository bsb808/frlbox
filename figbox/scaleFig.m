function scaleFig(sfac)

% scaleFig(sfac)
% scale the current figure by 'sfac'
%
% If sfac == 0, then scales to the matlab default.
% If sfac < 0, then scales to matlab default and then applies the -sfac.
% Use this for "absolute" scaling.
%
% Default 'sfac = 1.5'
%
% HISTORY
% 2008.03.01  bbing  Created documentation.

if nargin < 1
	sfac = 1.5;
end

% set to matlab's default on my laptop
if sfac <= 0
	set(gcf,'position',[420   528   560   420]);
    if sfac == 0
        return
    end
    sfac = -sfac;
end

pp = get(gcf,'position');
ll = pp(1);
bb = pp(2);
ww = pp(3);
ww1 = ww*sfac;
hh = pp(4);
hh1 = hh*sfac;
set(gcf,'position',[ll-(ww1-ww)/2 bb-(hh1-hh), ww1, hh1]);
