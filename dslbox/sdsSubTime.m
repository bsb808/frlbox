function strnew = strSubTime(strold,t0s,t0e,fieldstring)
% function strnew = strSubTime(strold,t0s,t0e,fieldstring)
%
% Extracts all the fields in a structure based on time
% str.t
% (or use the optional argument to specify a different string)
% 
% INPUT
% strold - original strucutre where each field is the same length - abe
% style
% t0s - start vale
% t0e - end value
% fieldstring - optional string specifying the field to use to for subset
%               default is 't'

if nargin < 4
    fieldstring = 't';
end

II = find(strold.(fieldstring)>=t0s);
JJ = find(strold.(fieldstring)<=t0e);

fields = fieldnames(strold);
for ii = 1:length(fields)
    strnew.(fields{ii}) = strold.(fields{ii})(II(1):JJ(end),:);
end

return
