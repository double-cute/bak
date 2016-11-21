function [lbs,ubs]=Grow(PBags,relevant)
%Given the positive bags and relevant features, expand a APR using the backfitting algorithm.

if(sum(relevant)==0)
    error('no relevant features');
end

size1=size(PBags);
num_bags=size1(1);
size2=size(relevant);
dimension=size2(2);

%”≥…‰œ‡πÿ Ù–‘
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
PBags=temp_pbags;

%constructing minimax APR
for i=1:sum(relevant)
    tempmin=-1e20;
    tempmax=1e20;
    for j=1:num_bags
        temp1=min(PBags{j,1}(:,i));
        temp2=max(PBags{j,1}(:,i));
        if(temp2<tempmax)
            tempmax=temp2;
        end
        if(temp1>tempmin)
            tempmin=temp1;
        end
    end
    minimax(i,1)=tempmax;
    minimax(i,2)=tempmin;
end
center_pointer=(minimax(i,1)+minimax(i,2))/2;

%choosing initial "seed" positive instance
min_distance=1e20;
for i=1:num_bags
    size1=size(PBags{i,1});
    for j=1:size1(1)
        temp_distance=sum((center_pointer'-PBags{i,1}(j,:)).^2);
        if(temp_distance<min_distance)
            min_distance=temp_distance;
            starting_bags=i;
            starting_inst=j;
        end
    end
end

chosen=zeros(num_bags,sum(relevant));
chosen(1,:)=PBags{starting_bags,1}(starting_inst,:);
usage=zeros(1,num_bags);
usage(1,starting_bags)=1;
pointer_bags=zeros(1,num_bags);
pointer_instances=zeros(1,num_bags);
pointer_bags(1,1)=starting_bags;
pointer_instances(1,1)=starting_inst;

for i=2:num_bags
    %greedy step
    curAPR=minmax(chosen(1:(i-1),:)');
    curSize=sum(curAPR(:,2)-curAPR(:,1));
    incremental=1e20;
    for j=1:num_bags
        if(usage(1,j)==0)
            tempsize=size(PBags{j,1});
            for k=1:tempsize(1)
                tempAPR=minmax([curAPR';PBags{j,1}(k,:)]');
                temp_increment=sum(tempAPR(:,2)-tempAPR(:,1))-curSize;
                if(temp_increment<incremental)
                    incremental=temp_increment;
                    pointer_bags(1,i)=j;
                    pointer_instances(1,i)=k;
                    chosen(i,:)=PBags{j,1}(k,:);
                end
            end
        end
    end
    usage(1,pointer_bags(1,i))=1;
    
    %backfitting
    changed=1;
    while(changed==1)
        changed=0;
        for m=1:i
            tempAPR=[chosen(1:(m-1),:);chosen((m+1):i,:)];
            tempAPR=minmax(tempAPR');
            tempsize=sum(tempAPR(:,2)-tempAPR(:,1));
            incremental=1e20;
            cur_instance=pointer_instances(1,m);
            cur_bag=pointer_bags(1,m);
            size_cur_bag=size(PBags{cur_bag,1});
            for n=1:size_cur_bag(1)
                tempAPR1=minmax([tempAPR';PBags{cur_bag,1}(n,:)]');
                temp_increment=sum(tempAPR1(:,2)-tempAPR1(:,1))-tempsize;
                if(temp_increment<incremental)
                    incremental=temp_increment;
                    pointer_instances(1,m)=n;
                    chosen(m,:)=PBags{cur_bag,1}(n,:);
                end
            end
            if(pointer_instances(1,m)~=cur_instance)
                changed=1;
            end
        end
    end
end

resultAPR=minmax(chosen');
lbs=resultAPR(:,1)';
ubs=resultAPR(:,2)';
            