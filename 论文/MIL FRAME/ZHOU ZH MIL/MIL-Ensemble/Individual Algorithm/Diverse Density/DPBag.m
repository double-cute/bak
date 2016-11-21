function derivatives=DPBag(Point,Scales,PBag)
%  Compute the derivative of positive bag "PBag" with respect to Point and Scales, the result is returned in derivatives.

   size_pbag=size(PBag);
   for i=1:size_pbag(1)
       temp(i)=1-PInstance(Point,Scales,PBag(i,:));
       deriv_set(i,:)=DInstance(Point,Scales,PBag(i,:));
   end
   temp1=max(temp,eps);
   derivatives=prod(temp)*((1./temp1)*deriv_set);