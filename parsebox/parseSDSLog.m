function [sds] = parseSDSLog(str)

% Parsing an SDS (Sharps Data String)data string from sharps.
% This version deals with version 1.1 of the SDS
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

% initial ize
sds = [];
goodResult = 0;

% generic parser - strips the label and date out of the record
[label,dnum,dstr]=parseDSLog(str);

if label == -1
    sds = [];
    return;
end

% dstr is the data string (after the label and timestamp)
[label2,remm]=strtok(dstr);

if isempty(remm)
	scnt = 0;
else
	[aa scnt] = sscanf(remm,'%lf %lf %lf %lf %lf',5);
end
if scnt == 5
    veh.valid = aa(1);
    veh.bearing = aa(2);
    veh.deltaz = aa(3);
    veh.rangeh = aa(4);
    veh.ranges = aa(5);
    
    [valid_tok,remm] = strtok(remm);
    [brg_tok,remm] = strtok(remm);
    [dz_tok,remm] = strtok(remm);
    [rh_tok,remm] = strtok(remm);
    [rs_tok,remm] = strtok(remm);
    
    % break the rest of the string into Range Records
    II = findstr(remm,']');
    if length(II) > 0
        start = 1;
        
        clear RangeRecord
        for ii = 1:length(II)
            RangeRecord{ii} = remm(start:II(ii));
            start = II(ii)+1;
        end
        
		nr = length(RangeRecord);
        RR = []; 
        Raw = []; 
        rcnt = 1;
        % parse each range record
        for ii = 1:length(RangeRecord)
            [aa,scnt] = sscanf(RangeRecord{ii},'%s %f %s %f %s %f %f %f %f',9);
            
            if scnt == 9
                RR.tx(ii) = char(aa(1));
                RR.pwr(ii) = aa(2);
                RR.rx(ii) = char(aa(3));
                RR.gain(ii) = aa(4);
                RR.code(ii) = char(aa(5));
                RR.ttime(ii) = aa(6);
                RR.mag(ii) = aa(7);
                RR.threshtime(ii) = aa(8);
                RR.thresh(ii) = aa(9);
                
                II = findstr(RangeRecord{ii},'[');
				if length(II) > 0 
					RcvStr{ii} = RangeRecord{ii}(II(1):end);
					
					% RcvStr should have something like this - [*c43804 00042 00000 00050]
					[aa,scnt] = sscanf(RcvStr{ii},'[*%*c%d %d %d %d]');
					if scnt == 4
						Raw.mrange(ii) = aa(1);
						Raw.mmag(ii) = aa(2);
						Raw.trange(ii) = aa(3);
						Raw.tthresh(ii) = aa(4);
						goodResult = 1;
					end
				end
%                 rcnt = rcnt + 1;
%                 goodResult = 1;
            end
        end
    end
    
        
end

sds = [];
if goodResult
	sds.ttime = Raw.mrange;
	sds.tx = RR.tx;
	sds.rx = RR.rx;
	sds.gain = RR.gain;
	sds.code = RR.code;
    sds.dnum = dnum;
    sds.t = t_mat2unix(dnum);
else
    sds = -1;
end






