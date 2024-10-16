function exfig(dpi, fname)
%EXFIG  Wrapper function for using the EXPORT_FIG function for PNG file.
%   Sets default options for EXPORT_FIG and sets background color to white.
%   Exports as PNG file.
%   
%   EXFIG Prompts for a file name and exports with 300 dpi.
%   EXFIG(DPI) Exports figure as file with resolution of DPI
%       DPI as integer (default is 300)
%   EXFIG(DPI, FNAME) FNAME should not include .png extension.
% 
% Part of custom frlbox toolbox: https://github.com/bsb808/frlbox
%
% Requires the export_fig function be 'installed'.  The function is
% available from the Mathworks File Exchange
% http://www.mathworks.com/matlabcentral/fileexchange/23629
% 
% Also to use the painters renderer you need to install the ghostscript
% application.
% http://www.ghostscript.com 
%
% The script prints the current figure, so you will want to make sure that
% the figure you want to print is current.
% 
% Execute pubfig.m to set the default font size before creating the plot.
% This will alow you to make the fonts more readable.
%
% See Also: EXPORT_FIG, PUBFIG

if (nargin < 1)
    dpi=300;
end
if (nargin < 2)
    % This prompts for the file name as a string.
    fname = input('Specify Filename:','s');
end

echo on
% Sets the background color to white
set(gcf,'color','w')
% The syntax of the command has many options.  This works well for printing
% to both PNG and TIF files at 300 DPI resolution.  The painters renderer
% does a nice job of reproducing various linestyles (dashed and such)
% It is highly recommended that you read the documentationf or export_fig!
% eval(sprintf('export_fig %s -png -tif -r300 -painters',fname))
eval(sprintf('export_fig %s -png -r%d -painters',fname,dpi))
echo off