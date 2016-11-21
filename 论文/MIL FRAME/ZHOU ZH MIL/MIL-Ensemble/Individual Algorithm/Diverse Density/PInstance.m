function Prob=PInstance(Point,Scales,Instance)
%   Given an instance "Instance", the concept point "Point" and the scale vector "Scales", this function computes the probability of "Instance"
%   belongs to concept "Point" and "Scales" as described in [1]. The probability is returned in "Prob".
%
%   [1] Maron O. Learning from ambiguity [PhD dissertation]. Department of Electrical Engineering and Computer Science, MIT, 1998

    distance=(Scales.^2)*((Instance-Point).^2)';
    Prob=exp(-distance);