function newStr = structCat(str1,str2)

% function newStr = strAppend(str1,str2)
% 
% Assuming a structure with fields that are column vectors (ala abe), this
% function concatenates the structures.
% The two structures need to have the same field names
%
% ex. LBL = strCat(lbl1,lbl2)
%
% HISTORY
% 07.11.04  bsb  Sohn04

newStr = [];

if ~isa(str2,'struct')
	newStr = str1;
	return;
end

if isempty(str1)
    newStr = str2;
else
    
    fnames = fieldnames(str2);
    
    for ii = 1:length(fnames)
		% check the number of columns
		nc1 = size(str1.(fnames{ii}),2);
		nc2 = size(str2.(fnames{ii}),2);
		if (nc1~=nc2)
			fprintf('Error (strCat) - # of columns unequal - aborting\n');
			newStr = str1;
			return;
		end

        newStr.(fnames{ii}) = [(str1.(fnames{ii})) ; (str2.(fnames{ii}))];
        %     
        %     setfield(newStr,fnames(ii),...
        %         [getfield(str1,fnames{ii}) ; getfield(str2,fnames{ii})])
    end
end

    