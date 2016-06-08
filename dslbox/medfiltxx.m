function [y,ym] = medfiltxx(x,m,dx)

n = length(x);
y = zeros(size(x));
ym = zeros(size(x));
mmax = m+5;
for i = 1+m: n-mmax,
  m0 = m;

  while(1)
    ind = [[i-m0:i-1]';[i+1:i+m0]'];
    x2 = x(ind);
    ind2 = find(x2 > 0);
    if(length(ind2) >= 2*m)break; end;
    m0=m0+1;
    if(m0>mmax)break; end
    if(m0>i-1)break; end
  end
  if(length(ind2) > 0)
    ym(i) = median(x2(ind2));
    if( (abs(x(i)-ym(i))) < dx)
      y(i)=x(i);
    end
  end
end

