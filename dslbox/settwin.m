figure(1)
if(exist('tmin'))

   handle = get(gcf,'Children') ;
   for i = 1:length(handle)
      if(strcmp(get(handle(i),'Type'),'axes'))
   	   set(handle(i),'XLimMode','Manual','XLim',[tmin,tmax],'YLimMode','Auto') ;
      end
   end
end


