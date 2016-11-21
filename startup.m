% Startup script for MATLAB
% make a link (ln -s) to this file in /usr/local/MATLAB/VER/toolbox/local/
fprintf('Bingham Startup2.m\n');
format compact

% get rid of MEvent.  CASE! warning
!synclient HorizEdgeScroll=0 HorizTwoFingerScroll=0

% add paths recursively
%frlboxdir = '/home/bsb/Projects/util/frlbox';
frlboxdir = '/home/bsb/WorkingCopies/frlbox';
exportfigdir = '/home/bsb/WorkingCopies/export_fig';
DIRS = {frlboxdir,exportfigdir};
for ii = 1:length(DIRS)
    edir = DIRS{ii};
    if exist(edir)~=7
        fprintf('The directory <%s> does not appear to exist, so not adding path\n',edir);
    else
        fprintf('Adding <%s> to path, recursively\n',edir);
        %gendir = fullfile(edir,'generic');
        gendir = edir;
        addpath(gendir); % adding path for the genpath_generic function
        pstr = genpath_exclude(edir,{'.svn','.git'});
        %pstr = genpath_exclude(edir,'.git');
        addpath(pstr);
    end
end

%cd '/home/bsb/NPS/Classes/me2801-f15'
