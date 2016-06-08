function pwhdop2mat(datadir)

% converts all the *.PWHDOP files in a given directory to .mat files with
% 'dop' data structures
% 
% include the file separator in the datadir string!

dd = dir([datadir '*.PWHDOP']);
for ii = 1:length(dd)
    fname = [datadir dd(ii).name];
    fprintf('Reading - %s \n',fname);
    dop = read_dop(fname)
    fname = [datadir dd(ii).name(1:end-11)];
    fprintf('Saving ''dop'' to %s\n',fname);
    save([datadir dd(ii).name(1:end-11)],'dop')
end
