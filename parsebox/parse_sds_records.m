% Parse SDS Strings
% this script parses all the SDS data records in a particular directory.
% it does two things...
% - saves a .mat file for each .SDS text file
% - returns a large SDS structure with the concatenated strucutures
clear;
clear SDS;

fdir = 'C:\Users\bbing\Projects\SHARPS\sftwr\data\j2_112';

dd = dir(fdir);
SDS = [];

% what rx/tx pairs are we looking for
rx = 'cd';
tx = 'aa';

for ii = 1:length(dd)
    ffile = dd(ii).name;
    if (strfind(ffile,'.SDS')==(length(ffile)-3))
        fname = sprintf('%s%c%s',fdir,filesep,ffile);
        fprintf('Parsing %d of %d .SDS files - %s\n',...
            ii,length(dd),ffile);
        sds = sds_parse_file(fname);
        if ~isempty(sds)
            matfname = sprintf('%s%s',fname,'.mat');
            fprintf('Saving %s\n',matfname);
			save(matfname,'sds');
			
			
			clear sdsSub;
			for ii = 1:size(sds.tx,2);
				for jj = 1:length(rx)
					if sds.tx(1,ii) == tx(jj) && sds.rx(1,ii) == rx(jj)
						sdsSub.t = sds.t;
						sdsSub.dnum = sds.dnum;
						sdsSub.tx(:,jj) = sds.tx(:,ii);
						sdsSub.rx(:,jj) = sds.rx(:,ii);
						sdsSub.gain(:,jj) = sds.gain(:,ii);
						sdsSub.code(:,jj) = sds.code(:,ii);
					end
				end
			end
				
        SDS = structCat(SDS,sdsSub);
        else
            fprintf('SDS file appears empty - skipping\n');
        end
		

    end
end

     

