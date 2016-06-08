function exfigsall(label)

if nargin < 1
    label = 'fig';
end

fignums = findobj('type','figure');
if length(fignums) < 0
    disp('No figures to print!')
else
    for ii = 1:length(fignums)
        figure(fignums(ii));
        set(gcf,'color','w')
        n = get(fignums(ii),'Number');
        fname = sprintf('%s%d',label,n);
        echo on
        eval(sprintf('export_fig %s -png -r150 -painters',fname))
        echo off
    end

end
