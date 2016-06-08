function SDS = sds2mat(fdir);

% SDS = sds2mat(fdir)
% Parse .SDS files from Jason Van
% this script parses all the SDS data records in a particular directory.
% it does two things...
% - saves a .mat file for each .SDS text file
% - returns a large SDS structure with the concatenated strucutures
% clear;
% 
% HISTORY
% 2008.03.07  bbing  Added comments and cleaning up.
% Also adding the functionality to save an abe-like data structure

clear SDS;

% fdir = 'C:\Users\bbing\Projects\SHARPS\sftwr\data\j2_112';

dd = dir(sprintf('%s%c%s',fdir,filesep,'*.SDS'));
SDS = [];

% % what rx/tx pairs are we looking for
% rx = 'cd';
% tx = 'aa';

t0 = clock;

pCnt = 1;
SDS = struct([]);
for ii = 1:length(dd)
    ffile = dd(ii).name;
    if (strfind(ffile,'.SDS')==(length(ffile)-3))
        fname = sprintf('%s%c%s',fdir,filesep,ffile);
        fprintf('Parsing %d of %d .SDS files - %s\n',...
            ii,length(dd),ffile);
        [sds] = sds_parse_file(fname);
        if ~isempty(sds)		
			% make an abe-like data structure
			clear sdsa;
			nS = length(sds);
			sdsa.pose = zeros(nS,3);
			%sdsa.dnum = zeros(nS,1);
			sdsa.t = zeros(nS,1);
			sdsa.x = zeros(nS,1);
			sdsa.y = zeros(nS,1);
			sdsa.z = zeros(nS,1);
			sdsa.t0 = zeros(nS,1);
			sdsa.valid = zeros(nS,1);
			sdsa.error = zeros(nS,1);
			sdsa.MaxTime = zeros(nS,3);
			sdsa.MaxMag = zeros(nS,3);
			sdsa.ThTime = zeros(nS,3);
			sdsa.ThMag = zeros(nS,3);

			for jj = 1:nS
				if isempty(sds(jj).x) || isempty(sds(jj).x) || isempty(sds(jj).x)
					break;
				end
				pose = [sds(jj).x(1) sds(jj).y(1) sds(jj).z(1)];
				sdsa.x(jj) = sds(jj).x(1);
				sdsa.y(jj) = sds(jj).y(1);
				sdsa.z(jj) = sds(jj).z(1);
				sdsa.pose(jj,:) = pose;
				sdsa.t(jj) = sds(jj).t;
				sdsa.dnum(jj) = sds(jj).t;
				sdsa.valid(jj) = sds(jj).valid;
				sdsa.error(jj) = sds(jj).error;
				% for this you have to assume that everything is the same
				% size!
				sdsa.MaxTime(jj,:) = sds(jj).MaxTime;
				sdsa.MaxMag(jj,:) = sds(jj).MaxMag;
				sdsa.ThTime(jj,:) = sds(jj).ThTime;
				sdsa.ThMag(jj,:) = sds(jj).ThMag;
			end
			sdsa.dnum = t_unix2mat(sdsa.t);
			sdsa.t0 = sdsa.t - sdsa.t(1);

			% save the two data structures
			matfname = sprintf('%s%s',fname(1:end-4),'_sds','.mat');
            fprintf('Saving ''sds'' and ''sdsa'' to >>%s\n',matfname);
			save(matfname,'sds','sdsa');
			
			% Concatenate all the sds data structures
			if (pCnt == 1)
				SDS = sds;
			else
				SDS = [SDS sds];
			end
			pCnt = pCnt + 1;
% 			
% 			clear sdsSub;
% 			for ii = 1:size(sds.tx,2);
% 				for jj = 1:length(rx)
% 					if sds.tx(1,ii) == tx(jj) && sds.rx(1,ii) == rx(jj)
% 						sdsSub.t = sds.t;
% 						sdsSub.dnum = sds.dnum;
% 						sdsSub.tx(:,jj) = sds.tx(:,ii);
% 						sdsSub.rx(:,jj) = sds.rx(:,ii);
% 						sdsSub.gain(:,jj) = sds.gain(:,ii);
% 						sdsSub.code(:,jj) = sds.code(:,ii);
% 					end
% 				end
% 			end
% 				
%         SDS = structCat(SDS,sdsSub);
        else
            fprintf('SDS file appears empty - skipping\n');
        end
		

    end
end

fprintf('\n\nParsed %d .SDS files\n',length(dd));
fprintf('Elapsed time = %7.1f seconds\n',etime(clock,t0));


     

