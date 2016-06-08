function [] = cascadefigs(figH)

% tiles the figures on the screen
%
% figH is an optional vector of figure windows (handles)
% defaults to get all the figures
%
% bbing 21.06.04
%

if nargin < 1
    figH = findobj('type','figure');
end

if isempty(figH)
	fprintf('No figures to cascade!\n');
	return;
end

% rect = [left, bottom, width, height]
figH = sort(figH); % in ascending order
set(0,'Units','normalized');
ssize = get(0,'screensize');
nn = 0.05;
% upper left position
ULx = nn;
ULy = ssize(4)-2*nn;
% 
% n = ceil(sqrt(length(figH)));
% 
% [xx,yy] = meshgrid(linspace(ssize(1),ssize(3),n+1),linspace(ssize(2),ssize(4),n+1));
% xx = round(xx(:,1:end-1));
% yy = round(yy(1:end-1,:));
% dx = xx(1,2)-xx(1,1);
% dy = yy(2,1)-yy(1,1)-75;


for ii = 1:length(figH)
	set(figH(ii),'units','normalized');
	pp = get(figH(ii),'position');
	set(figH(ii),'position',[ULx max(ULy-pp(4),0) pp(3) pp(4) ],'units','normalized')
	ULx = ULx+nn;
	ULy = ULy-nn;
	figure(figH(ii));
end


        
        
        
        
        

    
    