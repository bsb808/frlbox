function result = safesave(fullfilename,varargin)

% SAFESAVE
% result = safesave(fullfilename)
%
% Convenience function for safely saving a logfile.  Basically this is a
% wrapper for 'save' which checks to make sure the file does not exist.  In
% addition it reports (fprintf) the results.  If the file exists it asks if
% it should overwrite the file.
%
% EXAMPLE
% safesave('matfilename','datavariable1','datavariable1');
%
% HISTORY
% 21.11.04  bbing  Created - Tivey04
%

% make the .mat explicit
II = strfind(fullfilename,'.mat');
if isempty(II)
    fullfilename = sprintf('%s.mat',fullfilename);
end

 yn = 'y';
if exist(fullfilename,'file')
    yn = input(sprintf('File exists...\n %s ...\n overwrite (y/[n])?',fullfilename),'s');
    if isempty(yn)
        yn = 'n';
    end
end
switch lower(yn)
    case 'y'
        cmdstr = sprintf('save(''%s''',fullfilename);
        for ii = 1:length(varargin)
            cmdstr = sprintf('%s,''%s''',cmdstr,varargin{ii});
        end
        cmdstr = sprintf('%s)',cmdstr);
        
        evalin('base',cmdstr);
        
        fprintf('Saved results as in to file...\n \t%s \n',...
            fullfilename);
    case 'n'
        fprintf('Results not saved \n')
    otherwise
        fprintf('Didn''t grok the y/n input - results not saved\n');
end