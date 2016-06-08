function [pp]=progressbar(pp,fign)

% 
% pp - fraction of completion
%
%
if nargin < 2
    fign = gcf;
end


cla;
set(fign,'doublebuffer','on')
patch([0 pp pp 0],[0 0 1 1],.4*[1 1 1])
patch([pp 1 1 pp],[0 0 1 1],[.9 .9 .9])
tt = text(.5,.5,sprintf('%5.3f',pp));
set(tt,'horizontalalignment','center')
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
pos = get(gcf,'position');
set(gcf,'position',[pos(1)  pos(2)   441    32]);

xlim([0 1])
ylim([0 1])
set(gcf,'menubar','none')
% this hack brings the window to the top
set(fign,'windowstyle','modal')
set(fign,'windowstyle','normal')
