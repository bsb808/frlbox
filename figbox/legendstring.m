function lstrcell = legendstring(numVec,varargin)

% lstrcell = legendstring(numVec,varargin)
% 
% A utility function for converting a numeric vector into a cell array for
% consumption by the 'legend' command.
%
% OPTIONS
% 'double' - puts each entry in twice
% 'format',<<format string>> - format the entries using the fprintf string
% 
% EXAMPLES
% numbers = [1 2.3 0.555];
% legend(legendstring(numbers));
% legend(legendstring(numbbers,'format','%4.2f meters')

%
% 24.10.2006  bbing  Finally documenting this one!
%

double = 0;
ii = 1;
fstr = '%f';

while ii <= length(varargin)
	switch lower(varargin{ii})
		case 'double'
			double = 1;
			ii = ii +1;
		case 'format'
			fstr = varargin{ii+1};
			ii = ii+2;
		otherwise
			fprintf('Argument <<%s>> not recognized \n',varargin{ii});
			ii = ii+1;
	end
end
		
if double
	newnumvec = zeros(length(numVec)*2,1);
	for ii = 1:length(numVec)
		newnumvec(2*(ii-1)+1:2*(ii)) = numVec(ii);
	end
	numVec = newnumvec;
end


lstrcell = cell(length(numVec),1);
for ii = 1:length(numVec)
	lstrcell{ii} = sprintf(fstr,numVec(ii));
end
