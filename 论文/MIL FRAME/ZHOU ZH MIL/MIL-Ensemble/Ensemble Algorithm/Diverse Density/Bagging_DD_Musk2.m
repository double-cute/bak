function Bagging_DD_Musk2(curdir)
%This function uses Bagging[1] paradigm to build ensemble of Diverse Density learners.
%The Musk2 data is partitioned into ten folds using function 'divide_10fold_Musk2' where all the resulting files are stored in 'curdir', in each fold, Bagging is used
%to build an ensemble for Diverse Density learners. Each ensemble comprises five versions of the based multi-instance learner.
%
% For more details of Ensembles of Multi-Instance Learners, please refer to bibliography [2]
% [1] L. Breiman. Bagging predictors. Machine Learning, 24(2): 123-140, 1996.
% [2] Z.-H. Zhou and M.-L. Zhang. Ensembles of multi-instance learners. In: Lecture Notes in Computer Science 2837, Berlin: Springer-Verlag, 2003, 492-502.
	
    rand('state',sum(100*clock));%set initial seed for the random fucntion
	
	Dim=166;
	startingbags=1;
	instance_threshold=4;
	for fold=1:10
        trainIn=importdata(strcat(curdir,'\',num2str(fold),'\trainIn.txt'));
        trainOut=importdata(strcat(curdir,'\',num2str(fold),'\trainOut.txt'));
        info=importdata(strcat(curdir,'\',num2str(fold),'\info.txt'));   
        
        num_pos=info(1);
        num_neg=info(2);
        trainIn=trainIn/100;
        
	
        tempdir=strcat(curdir,'\',num2str(fold));
        for bags=1:5
            [status,msg]=mkdir(tempdir,strcat('DD_bagging',num2str(bags)));
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
            for pbags=1:pos_pointer
                tempsize=size(PBags{pbags});
                if(tempsize(1)<=instance_threshold)
                    indicators=indicators+1;
                    startings=[startings;PBags{pbags}];
                end
                if(indicators==startingbags)
                    break;
                end
            end
            
            if(indicators~=startingbags)
                error('not enough starting points...');
            end
            
            [Concepts,maxConcept,Iterations]=maxDD(PBags,NBags,Dim,ones(1,Dim),startings,[Dim,Dim],[1e-2,1e-2,1e-4,1e-4]);
            matfiles=strcat(tempdir,'\DD_bagging',num2str(bags),'\Musk.mat');
            save(matfiles,'Concepts','maxConcept','Iterations');  %save files
            
            clear startings;  %clear temporary files
            clear PBags;
            clear NBags;
        end
	end
