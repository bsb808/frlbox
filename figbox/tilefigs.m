function [] = tilefigs(figH)

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
	fprintf('No figures to tile!\n');
	return;
end

figH = sort(figH); % in ascending order

ssize = get(0,'screensize');

n = ceil(sqrt(length(figH)));

[xx,yy] = meshgrid(linspace(ssize(1),ssize(3),n+1),linspace(ssize(2),ssize(4),n+1));
xx = round(xx(:,1:end-1));
yy = round(yy(1:end-1,:));
dx = xx(1,2)-xx(1,1);
dy = yy(2,1)-yy(1,1)-75;


cnt = 1;
for ii = 1:n
    for jj = 1:n
        if cnt > length(figH)
            return;
        end
        
        % rect = [left, bottom, width, height]
        set(figH(cnt),'position',[xx(ii,jj) yy(ii,jj) dx dy],'units','pixel')
        figure(figH(cnt));
        cnt = cnt+1;
    end
end

        
        
        
        
        

    
    