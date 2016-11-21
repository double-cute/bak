function Prob=NLDD(Point,Scales,PBags,NBags)
%Given the positive bags 'PBags', negative bags 'NBags', referece point 'Point' and corresponding scales 'Scales', retures the negative 
%log-likelihood of diverse density with respect to 'Point' and 'Scales'.
   size_PBags=size(PBags);
   size_NBags=size(NBags);
   for i=1:size_PBags(1)
       temp(i)=PPBag(Point,Scales,PBags{i});
   end
   for i=(size_PBags(1)+1):(size_PBags(1)+size_NBags(1))
       temp(i)=PNBag(Point,Scales,NBags{i-size_PBags(1)});
   end
   Prob=-sum(log(max(temp,1e-7)));