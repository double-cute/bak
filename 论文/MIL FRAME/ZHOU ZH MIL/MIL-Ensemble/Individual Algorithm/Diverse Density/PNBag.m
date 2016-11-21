function Prob=PNBag(Point,Scales,NBag)
%   Given a negative bag "NBag", the concept point "Point" and the scale vector "Scales", this function computes the probability of Pr(t|NBag) 
%   as described in [1]. In this function, Pr(t|NBag) is computed using the "noisy-or" model and returned in "Prob".
%
%   [1] Maron O. Learning from ambiguity [PhD dissertation]. Department of Electrical Engineering and Computer Science, MIT, 1998


    size_nbag=size(NBag);
    for i=1:size_nbag(1)
        temp(i)=PInstance(Point,Scales,NBag(i,:));
    end
    Prob=prod(1-temp);