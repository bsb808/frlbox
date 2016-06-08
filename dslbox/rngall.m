clf
plot1
ttplt
plot2
for i = 1:5,
ind1 = find(lbl.status(:,1) == i);
ind2 = find(lbl.status(:,2) == i);
ind3 = find(lbl.status(:,3) == i);
ind4 = find(lbl.status(:,4) == i);
plot(lbl.t0(ind1)/60,lbl.r(ind1,1),'r.', ...
     lbl.t0(ind2)/60,lbl.r(ind2,2),'g.', ...
     lbl.t0(ind3)/60,lbl.r(ind3,3),'b.', ...
     lbl.t0(ind4)/60,lbl.r(ind4,4),'k.');
switch(i)
     case 1
            title('Old range');
     case 2
            title('Range too long');
     case 3
            title('Failed median');
     case 4
            title('high error');
     case 5
            title('good ranges');
end
pause
end


