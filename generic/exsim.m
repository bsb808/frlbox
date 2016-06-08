function exsim(modelname)

% Check for subsystems
nn = strfind(modelname,'/');
if ~isempty(nn)    
    mfname = sprintf('%s.slx',modelname(1:nn-1));
else
    mfname = sprintf('%s.slx',modelname);
end

if exist(mfname)~=4
    fprintf('The model <%s> does not seem to exist in your path!\n',mfname);
    return
end
load_system(modelname);

% make sure we don't overwrite the output
outname = strrep(modelname,'/','_');
outfname = sprintf('%s.svg',outname);
cnt=1;
while exist(outfname)==2
    outname = sprintf('%s%d',strrep(modelname,'/','_'),cnt);
    outfname=sprintf('%s.svg',outname);
    cnt=cnt+1;
end

fprintf('Saving the model <%s> as <%s>\n',modelname,outfname);
saveas(get_param(modelname,'Handle'),outname,'svg');

fprintf('Using inkscape to convert to EPS\n');
cmd=sprintf('inkscape -z --file=%s.svg --export-eps=%s.eps --export-area-drawing --export-dpi=300',outname,outname');
unix(cmd,'-echo');

fprintf('Using inkscape to convert to PNG\n');
cmd=sprintf('inkscape -z --file=%s.svg --export-png=%s.png --export-area-drawing --export-dpi=300',outname,outname');
unix(cmd,'-echo');