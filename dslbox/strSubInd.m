function newStr = strSubInd(str,ivector)

% function newStr = strSubInd(str,istart,iend)
% 
% Assuming a structure with fields that are column vectors (ala abe), this
% function truncates all the fields using the same indicies.
%
% INPUT
% str - original structure
% ivector - vector of indicies
%
% EXAMPLE
% async2 = strSubInd(async,[istart:iend]);
%
% HISTORY
% 07.11.04  bsb  Sohn04

newStr = [];

fnames = fieldnames(str);
for ii = 1:length(fnames)
    newStr.(fnames{ii}) = str.(fnames{ii})(ivector); 
end

    