function xyp(data,linetype)

if nargin < 2
    linetype = 'o';
end

plot(data.x,data.y,linetype)
