% GGA GumLog Example

fname = 'C:\users\bbing\Projects\gumstix\gumlog\00841_oval_gga.gumlog';
fname = 'C:\users\bbing\Projects\gumstix\gumlog\0081waban_gga.gumlog';
[GGA] = parseGumLogGGAFile(fname);

figure(1); clf;
plot(GGA.lon,GGA.lat,'.')
xlabel('Lon ("minutes")')
ylabel('Lon ("minutes")')
title('GPS GGA Positions - Waban')

II = find(GGA.valid==0);
hold on;
plot(GGA.lon(II),GGA.lat(II),'ro')


figure(2); clf;
% subplot(21)
plotyy(GGA.utc,GGA.lat,GGA.utc,GGA.lon,@dotplot);

hold on;
II = find(GGA.valid==0);
plotyy(GGA.utc(II),GGA.lat(II),GGA.utc(II),GGA.lon(II),@circplot);
ylabel('
