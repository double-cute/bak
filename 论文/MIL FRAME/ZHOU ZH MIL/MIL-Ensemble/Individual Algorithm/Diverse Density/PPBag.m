function Prob=PPBag(Point,Scales,PBag)
%   Given a positive bag "PBag", the concept point "Point" and the scale vector "Scales", this function computes the probability of Pr(t|PBag) 
%   as described in [1]. In this function, Pr(t|PBag) is computed using the "noisy-or" model and returned in "Prob".
%
%   [1] Maron O. Learning from ambiguity [PhD dissertation]. Department of Electrical Engineering and Computer Science, MIT, 1998
    
    size_pbag=size(PBag);
    for i=1:size_pbag(1)
        temp(i)=PInstance(Point,Scales,PBag(i,:));
    end
    Prob=1-prod(1-temp);