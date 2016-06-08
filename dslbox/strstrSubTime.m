function strnew = strstrSubTime(strold,t0s,t0e,fieldstring)
% function strnew = strstrSubTime(strold,t0s,t0e,fieldstring)
%
% Does the same thing as strSubTime except for structures of
% structures ala 'nav_t' or 'estIn'
%
% Extracts all the fields in a structure based on time
% str.t
% (or use the optional argument to specify a different string)
% 
% INPUT
% strold - original strucutre where each field is the same length - abe
% style
% t0s - start vale (probably unix time)
% t0e - end value
% fieldstring - optional string specifying the field to use to for subset
%               default is 't'

if nargin < 4
    fieldstring = 't';
end

ffields = fieldnames(strold);
for jj = 1:length(ffields)

  strnew.(ffields{jj}) = [];
  
  if ~isfield(strold.(ffields{jj}),fieldstring)
      strnew.(ffields{jj}) = strold.(ffields{jj});
  else
      
      II = find(strold.(ffields{jj}).(fieldstring)>=t0s);
      JJ = find(strold.(ffields{jj}).(fieldstring)>=t0e);
      
      fields = fieldnames(strold.(ffields{jj}));
      if (isempty(II) || isempty(JJ))
          fprintf('Warning (strstrSubTime.m): time out of bounds!\n')
          strnew.(ffields{jj}) = strold.(ffields{jj});
	  else
		  
          for ii = 1:length(fields)
			  % only cut down the fields of the same length as the orginal
			  % time
			  if size(strold.(ffields{jj}).(fields{ii}),1) == size(strold.(ffields{jj}).(fieldstring),1)
				  strnew.(ffields{jj}).(fields{ii}) = ...
					  strold.(ffields{jj}).(fields{ii})(II(1):JJ(1),:);
			  else
				  strnew.(ffields{jj}).(fields{ii}) = ...
					  strold.(ffields{jj}).(fields{ii});
			  end
          end
          
      end
  end
end


return
