function [GGA] = parseGumLogGGAFile(fname)
% Parse SDS Strings from a single file
%
% input - full file name
%
% OUTPUT
%SDS = 
%     ttime: [35852 40584]
%        tx: 'aa'
%        rx: 'cd'
%      dnum: 7.3228e+005
%         t: 1.1014e+009
% 
% HISTORY
% 29.11.04 bbing Created
% 05.12.006 bbing Updated for spec. version 1.6 and to eat DVLNAV strings

% fdir = 'C:\Users\bbing\Projects\SHARPS\sftwr\data\J2_112';
% ffile = '20041125_1508.SDS';
% fname = sprintf('%s%c%s',fdir,filesep,ffile);
% fname = 'C:\users\bbing\data\2006\Melville-MGLN10MV\EngineeringDive\EngDiveSharps\2006_11_08_19_00.SDS'
% fname = 'C:\users\bbing\Projects\gumstix\gumlog\00841b_gga.gumlog'
fid = fopen(fname);
str = fgets(fid);

% get file size
status = fseek(fid,0,'eof');
fsize = ftell(fid);
status = fseek(fid,0,'bof');
		fprintf('%s:%d of %d Kbytes parsed\n',...
			fname,floor(ftell(fid)/1000),floor(fsize/1000));
		
% GGA = struct([]);
% VEH = [];

pingFlag = 0;
pCnt = 1;
bcnt = 1;

% Initialize storage structure
fnames = {'utc','lat','lon','valid','nsat'}
for ii = 1:length(fnames)
	if pCnt == 1
		eval(sprintf('GGA.%s = [];',fnames{ii}));
	end
end
			
while (str~=-1)
    
	[label,dnum,datastr] = parseGumLogString(str);
	[gga] = parseGGAstring(datastr);
	if (~isempty(gga))
		for ii = 1:length(fnames)
			GGA.(fnames{ii})(pCnt) = str2num(gga.(fnames{ii}));
		end
		pCnt = pCnt + 1;
	end
	
    
%     if isa(sds,'struct') && isa(veh,'struct')
%         SDS = structCat(SDS,sds);
% 		VEH = structCat(VEH,veh);
%     end
%     
%     

    str = fgets(fid);
	
	
	% progress:
	if (floor(ftell(fid)/100000)>=bcnt)  % every 100kbyts
		fprintf('%s:%d of %d Kbytes parsed\n',...
			fname,floor(ftell(fid)/1000),floor(fsize/1000));
		bcnt = bcnt + 1;
	end
end

