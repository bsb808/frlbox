function xyp3(data1,data2,data3)

subplot(311)
plot(data1.x,data1.y,'.')
title('DVL')
subplot(312)
plot(data2.x,data2.y,'.')
title('EXACT')
subplot(313)
plot(data3.x,data3.y,'.')
title('LBL')

