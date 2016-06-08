function newStr = strstrCat(str1,str2)

% function newStr = strstrCat(str1,str2)
% 
% This is like strCat, but works on structures of strucutres (ex.,
% nav_t)
%
% Assuming a structure with fields that are column vectors (ala abe), this
% function concatenates the structures.
% The two structures need to have the same field names
%
% ex. nav_t = strstrCat(nav_t1,nav_t2);
%
% HISTORY
% 07.11.04  bsb  Created strCat - Sohn04
% 11.11.04  bsb  morphed strCat into strstrCat


newStr = [];

fnames = fieldnames(str1);
for ii = 1:length(fnames)
  
  ffnames = fieldnames(str1.(fnames{ii}));
  for jj = 1:length(ffnames)
    newStr.(fnames{ii}).(ffnames{jj}) = ...
	[str1.(fnames{ii}).(ffnames{jj}) ; ...
	 str2.(fnames{ii}).(ffnames{jj})];
  end
end


    