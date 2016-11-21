function [lbounds,ubounds]=Expand(PBags,lbs,ubs,relevant,tau,epsilon,step)
%Expand the current bounds lbs and ubs


if(sum(relevant)==0)
    error('no relevant features');
end

size1=size(PBags);
num_bags=size1(1);
size2=size(relevant);
dimension=size2(2);

%Ó³ÉäÏà¹ØÊôÐÔ
temp_pbags=cell(num_bags,1);
for i=1:num_bags
    count=0;
    for j=1:dimension
        if(relevant(1,j)==1)
            count=count+1;
            temp_pbags{i,1}(:,count)=PBags{i,1}(:,j);
        end
    end
end
positives=[];
for i=1:num_bags
    positives=[positives;temp_pbags{i,1}];
end

size2=size(positives);
num_instances=size2(1);
for i=1:sum(relevant)
    sigma=((lbs(1,i)-ubs(1,i))/2)/norminv((1-tau)/2);
    cur_dimension=[];
    for j=1:num_instances
        if((positives(j,i)>=lbs(1,i))&(positives(j,i)<=ubs(1,i)))
            cur_dimension=[cur_dimension,positives(j,i)];
         end
      end
    size3=size(cur_dimension);
    coeff=1/size3(2);
    
%    cur_dimension=sort(positives(:,i)');     
%    coeff=1/num_instances;
    
    templb=lbs(1,i);
    tempprob=coeff*sum(normcdf(templb,cur_dimension,sigma));
    while(tempprob>epsilon/2)
        templb=templb-step;
        tempprob=coeff*sum(normcdf(templb,cur_dimension,sigma));
    end
    tempub=ubs(1,i);
    tempprob=coeff*sum(normcdf(tempub,cur_dimension,sigma));
    while(tempprob<=(1-epsilon/2))
        tempub=tempub+step;
        tempprob=coeff*sum(normcdf(tempub,cur_dimension,sigma));
    end
    lbounds(1,i)=templb;
    ubounds(1,i)=tempub;
end