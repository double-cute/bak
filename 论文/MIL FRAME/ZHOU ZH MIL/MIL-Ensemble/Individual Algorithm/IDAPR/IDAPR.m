function [lbs,ubs,relevant]=IDAPR(PBags,NBags,Dim,threshold,tau,epsilon,step)
%  IDAPR  Using the Iterated-Discrim APR algorithm[1] to get the upper bounds and lower bounds of the relevant features which constitutes a hyper axis-parallel rectangle.
%     CKNN takes,
%        PBags     - an Mx1 cell array where the jth instance of ith positive bag is stored in PBags{i}(j,:)
%        NBags     - an Nx1 cell array where the jth instance of ith negative bag is stored in NBags{i}(j,:)
%        Dim       - the dimension of the instance
%        threshold - the threshold parameter used in Iterated-Discrim APR algorithm
%        tau       - the tau parameter used in Iterated-Discrim APR algorithm
%        epsilon   - the epsilon parameter used in Iterated-Discrim APR algorithm
%        step      - the step parameter used by the 'Expand' sub-routine          
%
%     and returns,
%        lbs       - the lower bound of the i-th feature is stored in lbs(1,i)
%        ubs       - the upper bound of the i-th feature is stored in ubs(1,i)
%        relevant  - an 1xDim array where if the i-th feature is relevant then relevant(1,i)==1, otherwise 0
%
% For more details, please reference to bibliography [1]
% [1] T. G. Dietterich, R. H. Lathrop, and T. Lozano-Perez. Solving the multiple-instance problem with axis-parallel rectangles. Artificial
%     Intelligence, 89(1-2): 31-71, 1997.

if(nargin<=6)
    error('not enough input parameter');
end

convergence=0;
iterations=0;
relevant=ones(1,Dim);
while(convergence==0)
    iterations=iterations+1;
    disp(strcat('Entering iteration:',num2str(iterations),'......'));
    
    disp(strcat('Entering Grow step......'));
    tic;
    [lbs,ubs]=Grow(PBags,relevant);
    toc;
    
    disp(strcat('Entering Discrimination step......'));
    tic;
    [relevant,convergence]=Discrim(NBags,lbs,ubs,relevant,threshold);
    toc;
end

disp(strcat('Entering Expand step......'));
tic;
[lbs,ubs]=Expand(PBags,lbs,ubs,relevant,tau,epsilon,step);
toc;