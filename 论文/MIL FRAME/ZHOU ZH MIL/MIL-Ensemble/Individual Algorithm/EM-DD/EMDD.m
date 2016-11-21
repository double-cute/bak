function [maxpoint,maxscales]=EMDD(Point,Dim,PBags,NBags,Epochs,Tol)
% EMDD  Finds the concept-point and corresponding scales using the EM-DD algorithm[1], routines for Diverse Density are required for this function. 
%    Syntax
%
%       [maxpoint,maxscales]=EMDD(Point,Dim,PBags,NBags,Epochs,Tol)
%
%    Description
%
%       maxDD(PBags,NBags,Dim,Scales,Epochs,Tol) takes,
%           Point   - A 1xDim starting vector
%           Dim     - Dimension of the instances
%           PBags   - An Mx1 cell array, the jth instance of ith positive bag is stored in PBags{i}(j,:) (1<=i<=M)
%           NBags   - An Nx1 cell array, the jth instance of ith negative bag is stored in Nbags{i}(j,:) (1<=i<=N)
%           Epochs  - Training epochs for the two gradient ascent steps performed in 'maxDD', default=[4*Dim,4*Dim]
%           Tol     - The delta x tolerance(tolx) and gradient tolerance(gtol) for the two gradient ascent steps of 'maxDD', default=[1e-5,1e-5,1e-7,1e-7]
%      and returns,
%           maxpoint  - the resulting concept point find by the EM-DD algorithm
%           maxscales - the corresponding scales of 'maxpoint'
%      
%    For more details,see [1] and [2].   
%
%    [1] Q. Zhang and S. A. Goldman. EM-DD: an improved multi-instance learning technique. In: Advances in Neural Processing Systems 14, Cambridge, MA:
%        MIT Press, 1073-1080, 2001.
%    [2] Maron O. Learning from ambiguity [PhD dissertation]. Department of Electrical Engineering and Computer Science, MIT, 1998


if(nargin<=5)
    Tol=[1e-5,1e-5,1e-7,1e-7];
end
if(nargin<=4)
    Epochs=[4*Dim,4*Dim];
end

scales=0.1*ones(1,Dim);
h=Point;
size_PBags=size(PBags);
size_NBags=size(NBags);
PosBags=cell(size_PBags(1),1);
NegBags=cell(size_NBags(1),1);

nldd1=NLDD(h,scales,PBags,NBags);
round=1;
indicator=1;
while((indicator==1))
    for i=1:size_PBags(1)
        temp=PBags{i,1};
        tempsize=size(temp);
        [min,index]=min(((temp-concur(h',tempsize(1))').^2)*((scales').^2));
        PosBags{i,1}=PBags{i,1}(index,:);
    end
    for i=1:size_NBags(1)
        temp=NBags{i,1};
        tempsize=size(temp);
        [min,index]=min(((temp-concur(h',tempsize(1))').^2)*((scales').^2));
        NegBags{i,1}=NBags{i,1}(index,:);
    end
    
    [Concepts,maxConcept,Iterations]=maxDD(PosBags,NegBags,Dim,scales,h,Epochs,Tol);
    h=maxConcept{1,1};
    scales=maxConcept{1,2};
    nldd0=nldd1;
    nldd1=NLDD(h,scales,PBags,NBags);
    
    if(abs(exp(-nldd1)-exp(-nldd0))<0.01*exp(-nldd0))
        indicator=0;
    end
    
    round=round+1;
    if(round>=11)
        indicator=0;
    end
end

maxpoint=h;
maxscales=scales;

