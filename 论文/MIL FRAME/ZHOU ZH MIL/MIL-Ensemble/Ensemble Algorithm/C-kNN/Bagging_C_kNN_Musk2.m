function Bagging_C_kNN_Musk2(curdir)
%This function uses Bagging[1] paradigm to build ensemble of Citation-kNN learners.
%The Musk2 data is partitioned into ten folds using function 'divide_10fold_Musk2' where all the resulting files are stored in 'curdir', in each fold, Bagging is used
%to build an ensemble for Citation-kNN learners. Each ensemble comprises five versions of the based multi-instance learner.
%
% For more details of Ensembles of Multi-Instance Learners, please refer to bibliography [2]
% [1] L. Breiman. Bagging predictors. Machine Learning, 24(2): 123-140, 1996.
% [2] Z.-H. Zhou and M.-L. Zhang. Ensembles of multi-instance learners. In: Lecture Notes in Computer Science 2837, Berlin: Springer-Verlag, 2003, 492-502.

	rand('state',sum(100*clock));%set initial seed for the random fucntion
	
	R=2;
	C=R+2;
	Dim=166;
	
	for fold=1:10
        trainIn=importdata(strcat(curdir,'\',num2str(fold),'\trainIn.txt'));
        trainOut=importdata(strcat(curdir,'\',num2str(fold),'\trainOut.txt'));
        testIn=importdata(strcat(curdir,'\',num2str(fold),'\testIn.txt'));
        testOut=importdata(strcat(curdir,'\',num2str(fold),'\testOut.txt'));
        info=importdata(strcat(curdir,'\',num2str(fold),'\info.txt'));   
        
        num_pos=info(1);
        num_neg=info(2);
        all=min_max_norm(0,1,[trainIn;testIn]);
        size1=size(trainIn);
        size2=size(testIn);
        trainIn=all(1:size1(1),:);
        testIn=all((size1(1)+1):(size1(1)+size2(1)),:);
        tempdir=strcat(curdir,'\',num2str(fold));
        
        %set testing bags
        for testbag=1:(info(3)+info(4))
            count=sum(testOut(1:(testbag-1)));
            testBags{testbag,1}=testIn((count+1):(count+testOut(testbag)),:);
        end
            
        for bags=1:5
            [status,msg]=mkdir(tempdir,strcat('CKNN_bagging',num2str(bags)));
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
            
                  
            labels=CKNN(PBags,NBags,testBags,R,C);
            matfiles=strcat(tempdir,'\CKNN_bagging',num2str(bags),'\Musk.mat');
            save(matfiles,'labels');  %save files
            
            clear PBags; %clear temporary variables
            clear NBags;
        end
        clear testBags;
	end
