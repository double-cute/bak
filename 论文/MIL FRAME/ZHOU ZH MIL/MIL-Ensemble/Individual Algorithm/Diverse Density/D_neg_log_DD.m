function derivatives=D_neg_log_DD(Point,Scales)
%   Given the concept point "Point" and scaling vector "Scales", compute the derivatives of the negative log-likelihood of diverse density with respect
%   to Point and Scales.

    global PositiveBags NegativeBags size_PBags size_NBags
    for i=1:size_PBags(1)
        temp(i)=PPBag(Point,Scales,PositiveBags{i});
        deriv_set(i,:)=DPBag(Point,Scales,PositiveBags{i});
    end
    for i=(size_PBags(1)+1):(size_PBags(1)+size_NBags(1))
        temp(i)=PNBag(Point,Scales,NegativeBags{i-size_PBags(1)});
        deriv_set(i,:)=DNBag(Point,Scales,NegativeBags{i-size_PBags(1)});
    end
    temp1=max(temp,eps);
    derivatives=-((1./temp1)*deriv_set);

    

    