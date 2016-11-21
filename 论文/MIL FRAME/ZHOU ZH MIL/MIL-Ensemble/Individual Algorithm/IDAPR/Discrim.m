function [result,convergence]=Discrim(NBags,lbs,ubs,relevant,threshold)
%Given the relevant features and negative bags, found the narrowed relevant features, which are returned as 'result'.

size1=size(NBags);
neg_instances=[];
for i=1:size1(1)
    neg_instances=[neg_instances;NBags{i,1}];
end

size2=size(neg_instances);
num_instances=size2(1);
dimension=size2(2);
lowerbounds=zeros(1,dimension);
upperbounds=zeros(1,dimension);
pointer=0;
for i=1:dimension
    if(relevant(1,i)==1)
        pointer=pointer+1;
        lowerbounds(1,i)=lbs(1,pointer);
        upperbounds(1,i)=ubs(1,pointer);
    end
end

count=0;
discrimed=zeros(num_instances,1); %标志当前已被排除的negative insances
under_consider=relevant;  %标志当前需要考虑的features
result=zeros(1,dimension); %存储当前已找出的features

while(~((count==num_instances)|(sum(under_consider)==0)))
    discrimlist=cell(dimension,1);
    for i=1:num_instances
        if(discrimed(i,1)==0)
            outdistance=zeros(1,dimension);
            for j=1:dimension
                if(under_consider(1,j)==1)
                    if(neg_instances(i,j)<lowerbounds(1,j))
                        outdistance(1,j)=abs(neg_instances(i,j)-lowerbounds(1,j));
                        if(outdistance(1,j)>=threshold)
                            discrimlist{j,1}=[discrimlist{j,1},i];
                        end
                    else
                        if(neg_instances(i,j)>upperbounds(1,j))
                            outdistance(1,j)=abs(neg_instances(i,j)-upperbounds(1,j));
                            if(outdistance(1,j)>=threshold)
                                discrimlist{j,1}=[discrimlist{j,1},i];
                            end                            
                        end
                    end                    
                end               
            end
            [maximum,index]=max(outdistance);
            if(maximum==0)
                discrimed(i,1)=1;
                count=count+1;
            else
                if(outdistance(1,index)<threshold)
                    discrimlist{index,1}=[discrimlist{index,1},i];
                end
            end
        end
    end
    discrim_num=zeros(1,dimension);
    for k=1:dimension
        tempsize=size(discrimlist{k,1});
        discrim_num(1,k)=tempsize(2);
    end
    [maximum,index]=max(discrim_num);
    if(maximum~=0)
        for m=1:maximum
            discrimed(discrimlist{index,1}(1,m),1)=1;
            count=count+1;
        end
    end
    under_consider(1,index)=0;
    result(1,index)=1;
end

if(sum(result~=relevant)==0)
    convergence=1;
else
    convergence=0;
end
                    
    