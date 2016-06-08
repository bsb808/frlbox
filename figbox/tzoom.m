function [xx,yy] = tzoom(cmd)

% use button '1' to zoom both time and y-axis
% use button '3' to zoom only time
% use button '2' to reset
% respect the x1<x2 rule!

if nargin < 1
	cmd = 'zoom';
end

switch lower(cmd)
	case 'zoom'
		[x1,y1,button] = ginput(1);
		subplots = get(gcf,'children');
		
		if button == 1 || button == 3
			
			disp('Adjusting equal x axes');
			
			[x2,y2,button] = ginput(1);
			xx = [x1 x2];
			yy = [y1 y2];
			for ii = 1:length(subplots)
				% 			axes(subplots(ii));
				% 			zoom on;
				% 			zoom reset;
				set(subplots(ii),'xlim',xx);
			end
			
			if button == 1
				set(gca,'ylim',yy);
			end
		elseif button == 2
			subplots = get(gcf,'children');
			disp('Reseting the plot');
			for ii = 1:length(subplots)
				axes(subplots(ii));
				xlim('auto');
				ylim('auto');
			end
		end
		
	case 'reset'
		subplots = get(gcf,'children');
		disp('Reseting the plot');
		for ii = 1:length(subplots)
			axes(subplots(ii));
			xlim('auto');
			ylim('auto');
		end
end

			
				