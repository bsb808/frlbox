% Startup script for MATLAB

% make a link (ln -s) to this file in /usr/local/MATLAB/VER/toolbox/local/
% Requires genpath_exclude which can be downloaded from matlab file
% exchange
% https://www.mathworks.com/matlabcentral/fileexchange/22209-genpath-exclude
fprintf('Bingham Startup2.m\n');
%>>>>>>> c3b645d1d8575c7846522f4f9c572296d94ddf60
format compact

% get rid of MEvent.  CASE! warning
!synclient HorizEdgeScroll=0 HorizTwoFingerScroll=0

frlboxdir = '/home/bsb/WorkingCopies/frlbox';
exportfigdir = '/home/bsb/WorkingCopies/export_fig';

% Add path to genpath_exclude before going forward
epath = fullfile(frlboxdir,'base');
addpath(epath);
% add paths recursively
%frlboxdir = '/home/bsb/Projects/util/frlbox%% (g)';

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
