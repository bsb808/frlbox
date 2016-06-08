function [pose] = lbl2d(ranges,Beacon,blFlag)

% 2D LBL Solution
%
% Beacon is a matrix of beacon locations - 2x2
% ranges is a length 2 vector of 1-way range
%
% IN
% ranges - 2x1 vector of ranges
% Beacon - 2x2 matrix of beacon locations (each row is a beacon)
% blFlag - forces the ambiguity in the solution
%           default = 1, set to -1 for the other solution
% OUT
% pose - 2d pose (or -1 if the geometry is bad)
%
% HISTORY
% 07.09.04  bbing  Created from previous versions

if nargin < 3
    blFlag = 1;
end

x1 = Beacon(1,1);
y1 = Beacon(1,2);
x2 = Beacon(2,1);
y2 = Beacon(2,2);

% Law of Cosines
aa = ranges(1);
bb = ranges(2);
cc = sqrt((x1-x2)^2 + (y1-y2)^2);

% num = (a^2-b^2- c^2);
% den = (-2*a*c);
% tmp = num/den;

% validity test
tmp = (bb^2-aa^2-cc^2)/(-2*aa*cc);
if abs(tmp) > 1
    pose = -1;
    return;
end

thb = acos( tmp );
dx = aa*cos(thb);
dy = blFlag * aa*sin(thb);

% Coordinate transform

% Find the rotation 
eps = 1e-6;  % avoid divide by zero
th = atan((y2-y1)/(x2-x1));
% Since the range of atan is from -pi/2 to pi/2, we have to be explicit
% about the direction
if (x2 < x1)
    th = th+pi;
end

x = x1 + dx*cos(th)-dy*sin(th);
y = y1 + dx*sin(th)+dy*cos(th);

pose = [x y];
% pose = [dx dy];


% debugging plot
% figure(10); 
% plot(pose(1),pose(2),'.')
% hold on 
% ang = linspace(0,2*pi,50);
% for ii = 1:size(Beacon,1)
%     pp = plot(Beacon(ii,1),Beacon(ii,2),'ro');
%     set(pp,'markerfacecolor','red');
%     % plot circles
%     xx1 = ranges(ii)*cos(ang) + Beacon(ii,1);
%     yy1 = ranges(ii)*sin(ang) + Beacon(ii,2);
%     plot(xx1,yy1,'r-')
% end
% fprintf('thb=%5.1f dx=%5.1f dy=%5.1f th=%5.1f a=%5.1f b=%5.1f c=%5.1f\n',...
%     thb*180/pi,dx,dy,th*180/pi,aa,bb,cc);
% 

return

