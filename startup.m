% Startup script for MATLAB

% make a link (ln -s) to this file in /usr/local/MATLAB/VER/toolbox/local/
% Requires genpath_exclude which can be downloaded from matlab file
% exchange
% https://www.mathworks.com/matlabcentral/fileexchange/22209-genpath-exclude
fprintf('Bingham Startup 2.0\n');
format compact

% get rid of MEvent.  CASE! warning
% Maybe not necessary for 2019b
%!synclient HorizEdgeScroll=0 HorizTwoFingerScroll=0

frlboxdir = '/home/bsb/WorkingCopies/frlbox';
exportfigdir = '/home/bsb/WorkingCopies/export_fig';
genpathexclude2dir = '/home/bsb/WorkingCopies/matlab-genpath2';

% Add path to genpath_exclude2 before going forward
%epath = fullfile(frlboxdir,'base');
epath = fullfile(genpathexclude2dir);
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
        pstr = genpath2(edir,{'.svn','.git'});
        %pstr = genpath2(edir,'.git');
        addpath(pstr);
    end
end

%cd '/home/bsb/NPS/Classes/me2801-f15'

% Necessary for saving MLX files in older versions of MATLAB on linux
% See - https://www.mathworks.com/matlabcentral/answers/1820980-error-when-saving-mlx-file
clear all 
tempdir  % ans = '/tmp/' 
mkdir matlabtmp
setenv('TMPDIR', '~/matlabtmp') 
clear all 
tempdir % ans = 'FILE DIRECTORY FOR THE NEW FOLDER'  