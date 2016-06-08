function s = datetime(t)
[year,month,day,hour,minute,second] = sec_to_ymdhms(t);
s = sprintf('%02d/%02d/%02d %02d:%02d',year,month,day,hour,minute);
