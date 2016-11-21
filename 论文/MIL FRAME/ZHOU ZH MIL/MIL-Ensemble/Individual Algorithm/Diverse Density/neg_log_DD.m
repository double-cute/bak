function Prob=neg_log_DD(Point,Scales)
%  Given the concept point "Point" and scaling vector "Scales", compute the negative log-likelihood of diverse density.

   global PositiveBags NegativeBags size_PBags size_NBags
   for i=1:size_PBags(1)
       temp(i)=PPBag(Point,Scales,PositiveBags{i});
   end
   for i=(size_PBags(1)+1):(size_PBags(1)+size_NBags(1))
       temp(i)=PNBag(Point,Scales,NegativeBags{i-size_PBags(1)});
   end
   Prob=-sum(log(max(temp,1e-7)));