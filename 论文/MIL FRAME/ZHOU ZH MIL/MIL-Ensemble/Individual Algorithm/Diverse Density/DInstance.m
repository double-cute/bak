function derivatives=DInstance(Point,Scales,Instance)
%  Compute the derivative of Instance with respect to Point and Scales, the result is returned in derivatives.
  
   temp=PInstance(Point,Scales,Instance);
   temp1=temp*2*((Instance-Point).*(Scales.^2));
   temp2=-temp*2*(Scales.*((Instance-Point).^2));
   derivatives=[temp1,temp2];
   
   

   