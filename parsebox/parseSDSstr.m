function [sds] = parseSDSstr(str)

% Parsing an SDS (Sharps Data String)data string from sharps.
% This version deals with version 1.6 of the SDS
%
% NOTE: currently, this version extracts the travel times as the value in
% the raw returned strings (within the brackets).
%
% OUTPUT
% returns sds = [] if there is an error
%
% HISTORY
% 23.11.04  bbing  Created - Tivey'04

% for debugging
%str ='LBL	04/11/01 12:01:53.50 	LBL	II,  9.0, DT, 306120141; RR,   7.5, B, 02.4400; RR,   7.5, B, 06.0195; RR,   7.5, B, 06.1667; RR,   7.5, B, 06.5446; RR,   7.5, B, 09.6035; RR,   8.0, A, 01.4824; RR,   8.0, A, 01.5981; RR,   8.0, A, 01.7142; RR,   8.0, A, 01.8870; RR,   8.0, A, 02.0030; RR,   8.0, A, 02.1811; RR,   8.0, A, 02.4158; RR,   8.0, A, 05.5747; RR,   8.0, A, 05.6902; RR,   8.0, A, 05.8064; RR,   8.0, A, 05.9545; RR,   8.0, A, 06.0717; RR,   8.0, A, 06.2641; RR,   8.0, A, 06.3878; RR,   8.0, A, 06.9406; RR,   8.0, A, 09.6701; RR,   8.0, A, 09.7897; RR,   8.0, A, 09.9139; RR,  10.5, C, 03.8491; RR,  10.5, C, 04.9991; RR,  10.5, C, 07.0368; RR,  10.5, C, 07.1501; RR,  10.5, C, 07.2848; RR,  10.5, C, 08.2274; RR,  10.5, C, 08.4317; RR,  11.0, B, 02.4429; RR,  11.0, B, 06.0212; RR,  11.5, A, 01.4800; RR,  11.5, A, 05.5728; RR,  15.0, -, 00.0108'
%  str ='SDS 2004/11/21 22:27:43.832 JAS2 1   -1.0   10.0  103.0  103.5 a 90 c 60 g 68156 236 0 1000 @[*c34838 00236 00000 01000] a 90 d 60 g 67934 609 0 1000 [*d34727 00609 00000 01000]'

% Here is a SDS string logged by DVLNAV
% str = 'HST 2006/11/08 19:00:02.642 SDS 2006/11/08 19:00:01.76 JAS2 1
% 35.8 -18.88  4.55  19.42  3.69  2.66 -18.88  0.20 a 90 b 90 d 6157 911
% 100 100[*b06157 00911 00090 00020] a 90 c 90 d 5956 1128 100 100[*c05956 01128 00092 00020] a 90 d 90 d 6245 907 100 100[*d06245 00907 00090 00020]';

% Here is an example from Fisher 2007
% str = 'SDS 2007/06/21 14:21:21.425 JAS2 1 183.7 -42.11  9.11  43.09 -9.10 -0.59 -42.11  0.00 a 99 b 99 d 13453 9223 100 100[*b 13453,09223,13450,06000,13453,09223 a 99 c 99 d 13440 9318 100 100[*c 13440,09318,13437,06000,13440,09318 a 99 d 99 d 13443 7365 100 100[*d 13443,07365,13441,06000,13443,07365 a 99 e 99 d 13446 10364 100 100[*e 13446,10364,13443,06000,13446,10364';

% initial size
sds = [];
goodResult = 0;

% generic parser - strips the label and date out of the record
[label,dnum,dstr]=parseDSLog(str);


% if it has a DVLNAV prefix, iterate
if strcmp(label,'HST')
	[label,dnum,dstr]=parseDSLog(dstr);
end

% if it is invalid, retrun
if (any(label == -1) || (~strcmp(label,'SDS')))
    sds = [];
    return;
end
	
% dstr is the data string (after the label and timestamp)
[label2,remm]=strtok(dstr);  % label2 is the vehicle (JAS2)

if isempty(remm)
	scnt = 0;
else
	[aa scnt] = sscanf(remm,'%lf %lf %lf %lf %lf %lf %lf %lf %lf',9);
end
if scnt == 9
    sds.valid = aa(1);
    sds.bearing = aa(2);
    sds.z = aa(3);
    sds.xyrange = aa(4);
    sds.xyzrange = aa(5);
	sds.x = aa(6);
	sds.y = aa(7);
	sds.z = aa(8);
	sds.error = aa(9);
    
    % break the rest of the string into Range Records
    %II = findstr(remm,']');
	JJ = findstr(remm,'[');
    if (length(JJ) > 0)% && (length(JJ)==length(II))
        clear RangeRecord
        for ii = 1:length(JJ)
			if ii == length(JJ)
				RangeRecord{ii} = remm(JJ(ii):end);
			else
				RangeRecord{ii} = remm(JJ(ii):JJ(ii+1));
			end
			RcvStr{ii} = RangeRecord{ii};
			% RcvStr should have something like this - [*c43804 00042 00000 00050]
			[bb,bcnt] = sscanf(RcvStr{ii},'[*%c');
			[aa,acnt] = sscanf(RcvStr{ii},'[*%*c %d, %d, %d, %d, %d, %d');
			if (acnt == 6 && bcnt == 1)
				sds.Node(ii) = bb;
				sds.MaxTime(ii) = aa(1);
				sds.MaxMag(ii) = aa(2);
				sds.ThTime(ii) = aa(3);
				sds.ThMag(ii) = aa(4);
				sds.MaxThTime(ii) = aa(5);
				sds.MaxThMag(ii) = aa(6);
				goodResult = 1;
			else
				goodResult = 0;
			end
		end	
	end
	%                 rcnt = rcnt + 1;
	%                 goodResult = 1;
end


if goodResult
    sds.dnum = dnum;
    sds.t = t_mat2unix(dnum);
else
    sds = -1;
end






