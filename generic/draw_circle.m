function [xx,yy] = circlePts(ctr,r,n)

%
% [xx,yy] = draw_circle(ctr,r,s,n)
% returns the points on a cirlce
% the circle is defined by a ctr (2x1), a scalar radius, and number of points
%
% bbing 11.11.02

if nargin < 3
	n = 20;
end

dangle = 2*pi / n;

pts = zeros(n,2);
Ang = 0;
for ii = 1:n+1
	Ang = Ang+dangle;
	xx = ctr(1)+r*cos(Ang);
	yy = ctr(2)+r*sin(Ang);
end

%pp = plot(pts(:,1),pts(:,2),s);

return
