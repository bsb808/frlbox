function str= sds2str(sds,nodeList)
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
if nargin < 2
	nodeList = 'bcde';
end


% Convert to an abe-like structure
ii = 1;
for ij = 1:length(sds)
	if isempty(sds(ii).valid)
		continue;
	end
	
	try
		str.t(ii) = sds(ii).t;
	catch
		hmm = 1;
	end
	str.valid(ii) = sds(ii).valid;
	str.z(ii) = sds(ii).z;
	str.xyrange(ii) = sds(ii).xyrange;
	str.xyzrange(ii) = sds(ii).xyzrange;
	str.x(ii) = sds(ii).x;
	str.y(ii) = sds(ii).y;
	
	for jj = 1:length(nodeList);
		II = find(sds(ii).Node == nodeList(jj));
		if (isempty(II))
			str.MaxTime(ii,jj) = -2;
			str.MaxMag(ii,jj) = -2;
			str.ThTime(ii,jj) = -2;
			str.ThMag(ii,jj) = -2;
			str.MaxThTime(ii,jj) = -2;
			str.MaxThMag(ii,jj) = -2;
		elseif length(II) == 1
			str.MaxTime(ii,jj) = sds(ii).MaxTime(II(1));
			str.MaxMag(ii,jj) = sds(ii).MaxMag(II(1));
			str.ThTime(ii,jj) = sds(ii).ThTime(II(1));
			str.ThMag(ii,jj) = sds(ii).ThMag(II(1));
			str.MaxThTime(ii,jj) = sds(ii).MaxThTime(II(1));
			str.MaxThMag(ii,jj) = sds(ii).MaxThMag(II(1));
		end
	end
	ii = ii+1;
end

str.t = str.t(:);
str.valid = str.valid(:);
str.z = str.z(:);
str.xyrange = str.xyrange(:);
str.xyzrange = str.xyzrange(:);
str.x = str.x(:);
str.y = str.y(:);