function derivatives=DNBag(Point,Scales,NBag)
%  Compute the derivative of negative bag "NBag" with respect to Point and Scales, the result is returned in derivatives.

   size_nbag=size(NBag);
   for i=1:size_nbag(1)
       temp(i)=1-PInstance(Point,Scales,NBag(i,:));
       deriv_set(i,:)=DInstance(Point,Scales,NBag(i,:));
   end
   temp1=max(temp,eps);
   derivatives=-prod(temp)*((1./temp1)*deriv_set);