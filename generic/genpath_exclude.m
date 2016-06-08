function pathstr = genpath_exclude(rootpath,excell)
% like genpath except accepts a cell array (or string) of paths to ignore
% e.g., .svn paths!

if strcmp(class(excell),'char')
    excell={excell};
end
P =genpath(rootpath);
C=strsplit(P,':');
CC = {};
jj=1;
for ii=1:length(C)
    include=1;
    for kk = 1:length(excell)
        if findstr(C{ii},excell{kk})
            include = 0
        end
    end
    if include
         CC{jj}=C{ii};
         jj=jj+1;
    end
end
pathstr = strjoin(CC,':');
return
    
