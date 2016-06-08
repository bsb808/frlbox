for i = 1:4,
	  lbl.tt_post(:,i) = lbl.tt(:,i);
 ind = find(lbl.tt(:,i) < 0);
lbl.tt_post(ind,i) = -1*ones(size(ind));
end
ind1 = find(lbl.tt_post(:,1) < 10000);
ind2 = find(lbl.tt_post(:,2) < 10000);
ind3 = find(lbl.tt_post(:,3) < 10000);
ind4 = find(lbl.tt_post(:,4) < 10000);
plot(lbl.tm(ind1),lbl.tt_post(ind1,1),'r.', ...
     lbl.tm(ind2),lbl.tt_post(ind2,2),'g.', ...
     lbl.tm(ind3),lbl.tt_post(ind3,3),'b.', ...
     lbl.tm(ind4),lbl.tt_post(ind4,4),'k.');
if(exist('xp'))
  title(sprintf('%.1f (r) %.1f (g) %.1f (b) %.1f (k)', ...
	      xp.freq(1),xp.freq(2),xp.freq(3),xp.freq(4)));
end

