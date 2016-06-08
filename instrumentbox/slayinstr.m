function []=slayinstr()

% For dealing with serial/UDP functionality in matlab.
% finds all the current instruments...
% closes
% frees (freeserial)
% deletes
%
% bbing - created summer 2003 at-sea
%

j=instrfind;
if ~isempty(j)
    for ii = 1:length(j)
		name = get(j(ii),'name');
		fprintf('%d: Closing <<%s>>\n',ii,name);
        fclose(j(ii));
            
        if strcmp(get(j(ii),'type'),'serial')
            fprintf('Slaying %d serial instruments\n',ii);
            freeserial(j(ii));
        end
        
        delete(j(ii));
    end
    fprintf('Slayed %d instruments!\n',length(j));
else
    fprintf('No instruments to slay at this time :(\n');
end

    
