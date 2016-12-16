% Startup script for MATLAB
% make a link (ln -s) to this file in /usr/local/MATLAB/[VER]/toolbox/local/
% e.g.,  sudo ln -s ~/WorkingCopies/frlbox/startup.m startup.m
fprintf('Bingham Startup.m\n');
format compact

% add paths recursively
%frlboxdir = '/home/bsb/Projects/util/frlbox';
frlboxdir = '/home/bsb/WorkingCopies/frl/util/frlbox';
if exist(frlboxdir)~=7
    fprintf('The directory <%s> does not appear to exist, so not adding path\n',frlboxdir);
else
    fprintf('Adding <%s> to path, recursively\n',frlboxdir);
    gendir = fullfile(frlboxdir,'generic');
    addpath(gendir); % adding path for the genpath_generic function
    pstr = genpath_exclude(frlboxdir,'.svn');
    addpath(pstr);
end

%cd '/home/bsb/NPS/Classes/me2801-f15'
