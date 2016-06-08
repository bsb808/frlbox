function [] = lbl2mat(lbldir)

% lbl2mat.m
%
% converst DSL LBL logs to matlab data strucutes with first returns
%
% INPUT
% operates on the current directory unless given an argument
%
% OUTPUT
% lbl.tnum - matlab formatted timestamp from DSL string
% lbl.ttime - travel times (2-way) from 455
% lbl.t0 - shorthand delta seconds form the beginning of the record
% lblnote.
%

t0 = clock;

if nargin < 1
    lbldir = '.'; %'C:\Users\bbing\Expeditions\Sohn04\renav\survey1'
end

% inputs that should be user specified!
		Slots = [7.5 8 10.5 11 11.5 14.5];
        Slabels = {'B','A','C','B','A','C'};  % corresponding labels

% ffile = '20041101_1200.LBL';
% fname = sprintf('%s%c%s',lbldir,filesep,ffile);

% Get the LBL files in the current directory
fmask = '*.LBL';
dd = dir(sprintf('%s%c%s',lbldir,filesep,fmask));

% Init
lblnote.Slots = Slots;
lblnote.Slabels = Slabels;

lbl.tnum = [];
lbl.ttime = [];

LBL.tnum = [];
LBL.ttime = [];


for di = 1:length(dd)
    lfname = dd(di).name;
    fname = sprintf('%s%c%s',lbldir,filesep,lfname);
    fbytes = dd(di).bytes;
    if fbytes < 2
        fprintf('%s is too small and being ignored! \n',lfname);
    else
        
		fid = fopen(fname);
		
		clear Tx Rx Dnum
        
		cnt = 1;
        progress_mod = 100;  % how many reads to do between reports (bytes)
		while ~feof(fid)
            lstr = fgets(fid);
            if lstr ~= -1
                
                [dnum,tx,rx] = parseLBLog(lstr);
                %[dnum(cnt),tx,rx] = parseLBLog(lstr);
                if dnum ~= -1
                   Dnum(cnt) = dnum;
                   Tx{cnt} = tx;
                   Rx{cnt} = rx;
                   cnt = cnt+1;
               end
                
                % report progress
                if (mod(cnt,progress_mod) == 0  || cnt==2)
                    fprintf('File %d of %d: Read %d of %d bytes \n',...
                        di,length(dd),ftell(fid),fbytes);
                end
            end
            
		end
        
        fclose(fid);
		
		% cook it down to first returns
        % get these from the xponder.dat file!
		TT = zeros(length(Rx),length(Slots));
		
		for ii = 1:length(Rx)
            for jj = 1:length(Slots)
                II = find(Rx{ii}.slot == Slots(jj));
                if ~isempty(II)
                    ttt = Rx{ii}.tt{II};
                    TT(ii,jj) = ttt(1);
                end
            end
		end
	%     plot(Dnum,TT,'.')
	%     legend('Slabels')
        
        % put together a structure
        lbl.tnum = Dnum;
        lbl.ttime = TT;
        
         % save as a .mat file
        mfname = sprintf('%s.mat',fname);
        %     if ~exist(mfname,'file')
        save(mfname,'lbl','lblnote');
        fprintf('Saved mat file - %s \n',mfname);
        
        % also make a grand structure with everything - we don't seem to be
        % memory constrained
        LBL.tnum = [LBL.tnum ; Dnum(:)];
        LBL.ttime = [LBL.ttime ; TT];
        
        
       
    end
end


lbl = LBL;
lbl.t0 = (lbl.tnum-lbl.tnum(1)) *24*3600;
lblnote = lblnote; % this should be the same each time
bigfname = sprintf('%s%cSURVEY.LBL.mat',lbldir,filesep);
save(bigfname,'lbl','lblnote');


fprintf('\nDONE! - Elapsed time = %7.1f s \n Saved the whole enchilda in... \n %s\n',...
    etime(clock,t0),bigfname);

%     
%     lbl.tnum = [lbl.tnum ; Dnum(:)];
%     lbl.ttime = [lbl.ttime ; TT];
    
    
% end
%  
% % add some important info - non-data tags
% lblnote.Slots = Slots;
% lblnote.Slabels = Slabels;
% 
% lbl.t0 = (lbl.tnum-lbl.tnum(1))*24*3600;
% plot(lbl.t0/60,lbl.ttime,'.')
% legend(lblnote.Slabels)
% 
% % Logging
% % save the structure
% log_flag = 1;  % 0 - off ; 1 - on
% log_dir = '.'; %y'C:\Users\bbing\expeditions\sohn04\renav\lbl_process';
% log_name = ['j2lbl.mat'];
% log_fname = sprintf('%s%c%s',log_dir,filesep,log_name);
% 
% if log_flag
%     yn = 'y';
%     if exist(log_fname,'file')
%         yn = input(sprintf('%s exists, overwrite (y/[n])?',log_fname),'s');
%         if isempty(yn)
%             yn = 'n';
%         end
%     end
%     switch lower(yn)
%         case 'y'
%             save(log_fname,'lbl','lblnote')
%             fprintf('Saved results as in to file - %s \n',log_fname);
%         case 'n'
%             fprintf('Results not saved \n')
%         otherwise
%             fprintf('Didn''t grok the input - results not saved\n');
%     end
%     
% else
%     fprintf('Log flag not set - results not saved\n');
% end
% 
% % End Logging
% 
% 
