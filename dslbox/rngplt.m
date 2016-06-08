ind1 = find(lbl.status(:,1) == 5);
ind2 = find(lbl.status(:,2) == 5);
ind3 = find(lbl.status(:,3) == 5);
ind4 = find(lbl.status(:,4) == 5);
plot(lbl.t0(ind1)/60,lbl.r(ind1,1),'r.', ...
     lbl.t0(ind2)/60,lbl.r(ind2,2),'g.', ...
     lbl.t0(ind3)/60,lbl.r(ind3,3),'b.', ...
     lbl.t0(ind4)/60,lbl.r(ind4,4),'k.');
hold on
ind1 = find(lbl.status(:,1) ~= 5);
ind2 = find(lbl.status(:,2) ~= 5);
ind3 = find(lbl.status(:,3) ~= 5);
ind4 = find(lbl.status(:,4) ~= 5);
lh=plot(lbl.t0(ind1)/60,lbl.r(ind1,1),'r+', ...
     lbl.t0(ind2)/60,lbl.r(ind2,2),'g+', ...
     lbl.t0(ind3)/60,lbl.r(ind3,3),'b+', ...
     lbl.t0(ind4)/60,lbl.r(ind4,4),'k+');
for i = 1:4,
	  set(lh(i),'MarkerSize',10);
end
hold off
title(sprintf('%.1f (r) %.1f (g) %.1f (b) %.1f (k)', ...
	      1,2, 3,4);
%       xp.freq(1),xp.freq(2),xp.freq(3),xp.freq(4)));

