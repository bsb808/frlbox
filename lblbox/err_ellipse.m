function [xx,yy,xxMaj,yyMaj,xxMin,yyMin] = err_ellipse(CovM,CenterXY,del,npts)

% return x,y points of a 2-d error ellipse
%  [xx,yy,xxMaj,yyMaj,xxMin,yyMin] = err_ellipse(CovM,CenterXY,N)
%
%  xx and yy are the points on the error ellipse for plotting
% xxMaj,yyMaj,xxMin,yyMin are the points on the axes
%
% eg., 
% plot(xx,yy,'r-')
% plot(xxMaj,yyMaj,'r--')
% plot(xxMin,yyMin,'r--')
% 
% Chi-Square distribution with 2 dof
% del = 4.61 for 90% confidence
% d = 5.99 for 95% confidence
% d = 6.17 for two sigma




if nargin < 3
    del = 4.61; % 90% confidence
end

if nargin < 4
    npts = 25;
end

% Eigenvalues
[V,D] = eig(inv(CovM));
d = diag(D);

% Major and Minor Axes
% Magnitude
majMag = sqrt(abs(del/d(1)));
minMag = sqrt(abs(del/d(2)));
% Direction
majDir = V(:,1);
minDir = V(:,2);


xx = linspace(-majMag, majMag, npts);
yy = sqrt(minMag^2*(1 - (xx.^2)/(majMag^2)));

xxx = [xx xx(end:-1:1)];
yyy = [yy -yy(end:-1:1)];

% now rotate
if majDir(1) == 0
	th = pi/2;
else
	th = atan(majDir(2)/majDir(1));
end

R = [cos(th) -sin(th)
	sin(th) cos(th)];

XY = [xxx; yyy];
XYr = R*XY;

% Transform
xx = XYr(1,:) + CenterXY(1);
yy = XYr(2,:) + CenterXY(2);

% also return some points for the maj/min axes
xxMaj= majMag*[majDir(1) -majDir(1)] + CenterXY(1);
yyMaj = majMag*[majDir(2) -majDir(2)]+ CenterXY(2);
xxMin = minMag*[minDir(1) -minDir(1)]+ CenterXY(1);
yyMin = minMag*[minDir(2) -minDir(2)]+ CenterXY(2);
return;