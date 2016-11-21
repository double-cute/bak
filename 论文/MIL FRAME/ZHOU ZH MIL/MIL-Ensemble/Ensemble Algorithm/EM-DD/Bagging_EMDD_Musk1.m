function Bagging_EMDD_Musk1(curdir)
%This function uses Bagging[1] paradigm to build ensemble of EM-DD learners.
%The Musk1 data is partitioned into ten folds using function 'divide_10fold_Musk1' where all the resulting files are stored in 'curdir', in each fold, Bagging is used
%to build an ensemble for EM-DD learners. Each ensemble comprises five versions of the based multi-instance learner.
%
% For more details of Ensembles of Multi-Instance Learners, please refer to bibliography [2]
% [1] L. Breiman. Bagging predictors. Machine Learning, 24(2): 123-140, 1996.
% [2] Z.-H. Zhou and M.-L. Zhang. Ensembles of multi-instance learners. In: Lecture Notes in Computer Science 2837, Berlin: Springer-Verlag, 2003, 492-502.

	rand('state',sum(100*clock));%set initial seed for the random fucntion
	
	Dim=166;
	Epochs=[4*Dim,4*Dim];
	Tol=[1e-5,1e-5,1e-7,1e-7];
	starting_bags=3;
	instances=5;
	bagging_num=5;
	
	for fold=1:10
        disp(strcat('fold:',num2str(fold)));
        trainIn=importdata(strcat(curdir,'\',num2str(fold),'\trainIn.txt'));
        trainOut=importdata(strcat(curdir,'\',num2str(fold),'\trainOut.txt'));
        info=importdata(strcat(curdir,'\',num2str(fold),'\info.txt'));   
        
        num_pos=info(1);
        num_neg=info(2);
        trainIn=trainIn/100;
        
	
        tempdir=strcat(curdir,'\',num2str(fold));
        for bags=1:bagging_num
            disp(strcat('training baggings:',num2str(bags),'......'));  
            [status,msg]=mkdir(tempdir,strcat('EMDD_bagging',num2str(bags)));
            if(status~=1)
                error('fail to create direcoty......');
            end
            
            %generate training set from the original training set via bootstrap sampling
            numbers=1:(num_pos+num_neg); 
            numbers=numbers';
            incremental=ceil(rand*100);
            for randpos=1:incremental
                [result,samples]=bootstrp(1,'copy',numbers);
            end      
            
            %set positive bags and negative bags for learning phase
            pos_pointer=0;
            neg_pointer=0;
            for sample=1:(num_pos+num_neg)
                count=sum(trainOut(1:(samples(sample)-1)));
                cur_sample=samples(sample);
                if(samples(sample)<=num_pos)
                    pos_pointer=pos_pointer+1;
                    PBags{pos_pointer,1}=trainIn((count+1):(count+trainOut(cur_sample)),:);
                else
                    neg_pointer=neg_pointer+1;
                    NBags{neg_pointer,1}=trainIn((count+1):(count+trainOut(cur_sample)),:);
                end
            end
            
            %set starting points
            startings=[];
            indicators=0;
            count=0;
            while(count~=starting_bags)
                cur=ceil(rand*pos_pointer);
                tempsize=size(PBags{cur,1});
                if(tempsize(1)<=instances)
                    startings=[startings;PBags{cur,1}];
                    count=count+1;
                end
            end
            
	
            tempsize=size(startings);
            features=zeros(tempsize(1),Dim);
            scales=zeros(tempsize(1),Dim);
        
            for i=1:tempsize(1)
                [h,s]=EMDD(startings(i,:),Dim,PBags,NBags,Epochs,Tol);
                features(i,:)=h;
                scales(i,:)=s;
                matfiles=strcat(tempdir,'\EMDD_bagging',num2str(bags),'\Musk.mat');
                save(matfiles,'features','scales');  %save files
            end            
                    
            clear PBags;  %clear temproray variables
            clear NBags;
        end
	end
