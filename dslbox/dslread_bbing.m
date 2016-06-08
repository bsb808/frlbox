function [out_struct] = dslread_bbing(filename,formatstring)

%DSLREAD Parse data from a DSL formatted file into a structure.
%   DSLREAD(FILENAME) reads data in from the DSL data file FILENAME into
%   an automatically named structure containing a Unix time field (.t) in
%   addition to fields automatically generated based on the file's data
%   content.  If DSLREAD is called with an output argument, 
%   [MY_STRUCT] = DSLREAD(FILENAME), MY_STRUCT will be used as the
%   output structure's name instead.
%
%   DSL_READ only works on data files of a specific format.  The first two
%   lines of the file to be read must be of the format:
%
%      XXX structure_name
%      XXX yy/mm/dd hh:nn:ss data_field1 data_field2 etc...
% 
%   The last field of the first line indicates the desired name of the
%   output structure.  Calling DSL_READ with an output argument overrides
%   this.  The second line must include the string 'XXX yy/mm/dd hh:nn:ss'
%   followed by the desired names for the subsequent data fields.  Data 
%   fields can be stored as columns in a matrix, which will itself be 
%   stored as a single field in the output structure, using the notation 
%   'field_name(number_of_columns)' in the corresponding location(s) on the
%   second line of the input file.  Data fields corresponding to any fields
%   in the format line preceeded immediately by the '*' character are
%   ignored.
%
%   All subsequent lines of the file must have data fields that match the
%   standard DSL data format.  Data fields appearing after the 'ss' field
%   can contain strings, floating-point numbers, or integers.  Data fields
%   can be delimited by any characters that are not letters, numbers, 
%   parentheses, the '*' character, or the '_' character, provided that
%   delimiting characters do not also appear in any string data, and that
%   the second line of the file includes the additional delimiting
%   characters in their corresponding places.  Data fields can have variable
%   numbers of delimiting characters between them allowing data fields of
%   variable length to be aligned in columns in the file.
%
%   DSL_READ is built on AUTOREAD.  AUTOREAD can be used to parse similar 
%   data files containing two headerlines, but of more arbitrary format.
%
%   See also AUTOREAD, TEXT2STRUCT, TEXTREAD.

%History
%Date          Who        Comment
%----------    ---        -----------------------------------
%2001/08/08    mvj        Create
%2001/08/20    mvj        Added compatibility with header identifiers (e.g. 'PAS')
%                         for use with data files derived from unified logging 
%                         processes, and separated using 'fgrep' or an equivalent.
%2001/08/24    mvj        Added error to catch invalid filename
%2001/09/10    mvj        .t field now appears first in created structure
%2004/07/15    mvj        now parses string fields preceeded by '0x' into decimal
%                         via hex2dec.m


% retrieve the line contraining the desired output structure name
fid = fopen(filename,'rt');
if (fid == -1)
   error('Invalid filename');
end
name_line = fgetl(fid);
fclose(fid);

% ignore headers in name_line to determine desired structure name
% i = length(name_line);
% name = '';
% while (i ~= 0 & name_line(i) ~= ' ')
%    name = strcat(name_line(i),name);
%    i = i - 1;
% end

% initialize structure with .t field
raw.t = 0;

% read in file using AUTOREAD
raw = autoread_bbing(filename,formatstring,raw);

% check to make sure file is in DSL format and mark fields for removal
field_names = fieldnames(raw);
eval(sprintf('fields_no = {''%s'' ''yy'' ''mm'' ''dd'' ''hh'' ''nn'' ''ss''};',char(field_names(2))));
for i = 1:length(fields_no)
   if (~isfield(raw,fields_no{i}))
      err_msg = sprintf('Header of ''%s'' is not formatted for use with DSLREAD.', ...
         filename);
      error(err_msg);
   end
end

% convert yy/mm/dd hh:nn:ss data to unix time [s]
raw.t = ymdhms_to_sec(raw.yy,raw.mm,raw.dd,raw.hh,raw.nn,raw.ss);

% parse any cell arrays of hex strings ('0x') into decimal numbers
for i = 1:length(field_names)
  if eval(sprintf('iscell(raw.%s)',field_names{i})) % string data will always be returned in cell arrays by autoread 
	  if eval(sprintf('size(raw.%s)',field_names{i})); % make sure it is non-zero length - bbing 30.11.04
		  eval(sprintf('tmp = raw.%s{1,1};',field_names{i}));
		  if isstr(tmp) & strncmp(tmp,'0x',2) % is it hex?
			  [M,N] = eval(sprintf('size(raw.%s)',field_names{i}));
			  buff = eval(sprintf('char(raw.%s)',field_names{i}));
			  buff = hex2dec(buff(:,3:end));
			  eval(sprintf('raw.%s = reshape(buff,M,N);',field_names{i}))
			  
		  end
	  end
  end
end

% remove marked fields to create output structure
raw = rmfield(raw,fields_no);

% output structure into workspace
if (nargout == 0)
   assignin('caller',name,raw);
   evalin('caller',name);
else
   out_struct = raw;
end

