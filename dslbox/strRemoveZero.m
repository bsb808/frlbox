function newStr = strRemoveZero(oldStr);

% newStr = strRemoveZero(oldStr);
% 
% For ABE-like strutures removes elements with zero time difference
%
% 01.07.2006 bbing Created
newStr = oldStr;
fnames = fieldnames(oldStr);

II = find(diff(oldStr.t)>0);
while ( length(II)+1 ~= length(oldStr.t) )
    fprintf('Removing %d of %d elements because dT = 0', ...
        length(II)+1 ~= length(oldStr.t),length(oldStr.t));
    for ii = 1:length(fnames)
        newStr.(fnames{ii}) = oldStr.(fnames{ii})(II+1); 
    end
    II = find(diff(newStr.t)>0);
end

    

    