function [dnum] = t_dsl2mat(dslTimeStr);

% Validates the dslTimeString
%
% bbing 26.07.03

t_vec = sscanf(dslTimeStr,'%d/%d/%d %d:%d:%f');
dnum = datenum(t_vec(1),t_vec(2),t_vec(3),t_vec(4),t_vec(5),t_vec(6));

str = dslTimeStr;
yyyy = str(1:4);
mm = str(6:7);
dd = str(9:10);
hh = str(12:13);
mm = str(