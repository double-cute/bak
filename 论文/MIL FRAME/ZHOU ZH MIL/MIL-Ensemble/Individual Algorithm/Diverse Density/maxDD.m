function [Concepts,maxConcept,Iterations]=maxDD(PBags,NBags,Dim,Scales,SPoints,Epochs,Tol)
% maxDD  Finds the concept with the maximum Diverse Density[1] given the positive bags and negative bags. 
%    This routine learns from a single-point-and-scaling concept class using multiple gradient based optimizations, it also uses the "noisy-or" model to 
%    estimate a density. This routine takes two gradient ascent steps, it first performs line searches (lnsrch in [2]) along the gradient direction using 
%    a loose  convergence criterion. After the first step converges, the second step performs a quasi-newton search (dfpmin in [2]) from that point.  The
%    number of iterations allowed for each optimization was at least two times the number of dimensions of the search space.
%
%    Syntax
%
%       [Concepts,MaxConcept,Iterations]=maxDD(PBags,NBags,Dim,Scales,SPoints,Epochs,Tol)
%
%    Description
%
%       maxDD(PBags,NBags,Dim,Scales,Epochs,Tol) takes,
%           PBags   - An Mx1 cell array, the jth instance of ith positive bag is stored in PBags{i}(j,:) (1<=i<=M)
%           NBags   - An Nx1 cell array, the jth instance of ith negative bag is stored in Nbags{i}(j,:) (1<=i<=N)
%           Dim     - Dimension of the instances
%           Scales  - Initial scaling vector for maxDD, default=ones(1,Dim)
%           SPoints - A KxDim matrix, where each line is a starting point for the two gradient ascent steps, default=[all positive instances]
%           Epochs  - Training epochs for the two gradient ascent steps performed in this routine, default=[4*Dim,4*Dim]
%           Tol     - The delta x tolerance(tolx) and gradient tolerance(gtol) for the two gradient ascent steps, default=[1e-5,1e-5,1e-7,1e-7]
%      and returns,
%           Concepts    - A Kx3 cell array, for ith starting point in SPoints, the returned concept point,scaling vector and diverse density is 
%                         stored in Concepts{i,1}, Concepts{i,2} and Concepts{i,3} accordingly
%           MaxConcept  - An 1x3 cell array which stores the "best" concept point, scaling vector and diverse density in MaxConcept{1}, MaxConcept{2}
%                         and MaxConcept{3}
%           Iterations  - An Kx2 matrix, where the number of iterations of "lnsrch" and "dfpmin" of ith staring point in SPoint is stored in Iterations(i,1)
%                         and Iterations(i,2)
%
%
%      It is worth noted that, given two point(Pt1 and Pt2) and the scaling vector(Scales),the distance between the two points is computed as 
%      (Scales.^2)*((Pt1-Pt2).^2)', not Scales*((Pt1-Pt2).^2)', so it is possible that some features of the scaling vector to be small negative numbers.
%      
%    For more details,see [1] and [2].   
%
%    [1] Maron O. Learning from ambiguity [PhD dissertation]. Department of Electrical Engineering and Computer Science, MIT, 1998
%    [2] Press W H, Teukolsky S A, Vetterling W T, Flannery B P. Numerical Recipes in C: the art of scientific computing. Cambrige University Press,  
%        New York, 2nd Edition, 1992

%  Initialize
    if(nargin<=2)
        error('Not enough input parameters, please check again.');
    end
    
    global PositiveBags NegativeBags size_PBags size_NBags
    PositiveBags=PBags;
    NegativeBags=NBags;
    size_PBags=size(PBags);
    size_NBags=size(NBags);
    
    size_of_pos_instance=size(PBags{1});
    size_of_neg_instance=size(NBags{1});
    if(Dim~=size_of_pos_instance(2)|Dim~=size_of_neg_instance(2)|size_of_pos_instance(2)~=size_of_neg_instance(2))
        error('Error input of instance dimension');
    end
    
    if(nargin<=6)
        Tol=[1e-5,1e-5,1e-7,1e-7];
    end
    if(nargin<=5)
        Epochs=[4*Dim,4*Dim];
    end
    if(nargin<=4)
        pointer=0;
        for i=1:size_PBags(1)
            temp_size=size(PBags{i});
            for j=1:temp_size(1)
                pointer=pointer+1;
                SPoints(pointer,:)=PBags{i}(j,:);
            end
        end
    end
    if(nargin<=3)
        Scales=ones(1,Dim);
    end
    
    temp_size=size(SPoints);
    num_starting_point=temp_size(1);
    Concepts=cell(num_starting_point,3);
    Iterations=zeros(num_starting_point,2);
    maxConcept=cell(1,3);
    maxConcept{1}=zeros(1,Dim);
    maxConcept{2}=ones(1,Dim);
    maxConcept{3}=0;
    
%  Begin Diverse Density maximizing
  
   for i=1:num_starting_point
       tic;
       disp(strcat('Maxmizing diverse density for positive instance: ',num2str(i),'......'));  %  For every staring point, perform the following two gradient ascent routine
       instance=SPoints(i,:);
       xold=[instance,Scales];
       fold=neg_log_DD(instance,Scales);
       g=D_neg_log_DD(instance,Scales);
       p=-g;
       sum=xold*xold';
       stpmax=100*max(sqrt(sum),2*Dim);
       
       disp('Entering lnsrchs......');
       for iter=1:Epochs(1)   %  The first gradient ascent step, i.e., line searches along the gradient direction using a loose convergence criterion(Tol(1:2))
           [xnew,fnew,check]=lnsrch(xold,Dim,fold,g,p,Tol(3),stpmax);
           xi=xnew-xold;
           test=max(abs(xi)./max(abs(xnew),1));         %Test for convergence on delta x, use a loose convergence criterion(Tol(1))
           if(test<Tol(1))
               break;
           end
           g=D_neg_log_DD(xnew(1:Dim),xnew((Dim+1):2*Dim));  %Get the new gradient
           den=max(fnew,1);   %Test for convergence on zero gradient, use a loose convergence criterion(Tol(2))
           test=max(abs(g).*max(abs(xnew),1))/den;
           if(test<Tol(2))
               break;
           end
           p=-g;  %Continue iterations
           xold=xnew;
           fold=fnew;
           sum=xold*xold';
           stpmax=100*max(sqrt(sum),2*Dim);
               
           if(mod(iter,50)==0)
               disp(strcat('Lnsrch epochs: ',num2str(iter),'......'));
           end
       end
       disp(strcat('Lnsrch completed in epochs: ',num2str(iter),'......'));          
       Iterations(i,1)=iter;
       
       disp('Entering Dfpmin......');
       [xnew,fret,iter]=dfpmin(xnew,Dim,Tol(3),Tol(4),Epochs(2));    %  The second gradient ascent step, i.e., performs a quasi-newton search (dfpmin in [2]) from the point xnew got by the first step using a convergence criterion(Tol(3:4))
       disp(strcat('Dfpmin completed in epochs: ',num2str(iter),'......'));
       
       Iterations(i,2)=iter;
       Concepts{i,1}=xnew(1:Dim);
       Concepts{i,2}=xnew((Dim+1):2*Dim);
       Concepts{i,3}=exp(-fret);
       
       if(exp(-fret)>maxConcept{3})
           maxConcept{1}=xnew(1:Dim);
           maxConcept{2}=xnew((Dim+1):2*Dim);
           maxConcept{3}=exp(-fret);
       end    
       toc;
   end

   
    clear global;

