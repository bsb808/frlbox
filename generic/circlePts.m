function [xx,yy] = circlePts(ctr,r,s,n)

%
% [xx,yy] = draw_circle(ctr,r,s,n)
% returns the points on a cirlce
% the circle is defined by a ctr (2x1), a scalar radius, and number of points
% if an argument 's' is passed as a string defining the linetype
% the cirlce is plotted.
%
% bbing 11.11.02
if nargin < 3
	s = 0
end

if nargin < 4
	n = 20;
end

dangle = 2*pi / (n-1);

pts = zeros(n,2);
Ang = 0;
for ii = 1:n
	Ang = Ang+dangle;
	xx(ii) = ctr(1)+r*cos(Ang);
	yy(ii) = ctr(2)+r*sin(Ang);
end

if s ~= 0
	pp = plot(xx,yy,s);
end

return
