function strnew = strSubValid(strold,fieldstring)
% function strnew = strSubValid(strold,[fieldstring])
%
% Extracts all the fields in an abe-like structure that have a '1' in the
% .valid field.  You may search for a '1' in other fields by specifiying
% an otional field string.
% 
% INPUT
% strold - original strucutre where each field is the same length - abe
% style
% fieldstring - optional string specifying the field to use to for subset
%               default is 'valid'

if nargin < 2
    fieldstring = 'valid';
end

II = find(strold.(fieldstring)==1);

fields = fieldnames(strold);
for ii = 1:length(fields)
    strnew.(fields{ii}) = strold.(fields{ii})(II,:);
end

return
