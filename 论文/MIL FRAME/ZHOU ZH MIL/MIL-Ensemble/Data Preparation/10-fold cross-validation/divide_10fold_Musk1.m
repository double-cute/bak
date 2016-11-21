function divide_10fold_Musk1(curdir)
%  This function divide the Musk1 dataset into ten folds, the input data include two parts:
%  all           -  A 476x166 matrix which contains all intances in all bags, positive bags and negative bags are stored sequentially
%  molecule_num  -  A 1x166 vector where the number of instances in i-th bag is stored in molecule_num(1,i), number of instances in positive bags and negative bags are stored sequentially
%
%  the output data include ten fold where each fold is stored in a sub-directory under 'curdir', the files under each fold are:
%  trainIn  -  A Mx166 matrix which stores all the instancs in training bags, positive bags and negative bags are stored sequentially
%  trainOut -  A 1xN vector where the number of instances in i-th training bag is stored in trainOut(1,i), number of instances in positive bags and negative bags are stored sequentially
%  testIn   -  A Px166 matrix which stores all the instancs in testing bags, positive bags and negative bags are stored sequentially
%  testOut  -  A 1xQ vector where the number of instances in i-th testing bag is stored in testOut(1,i), number of instances in positive bags and negative bags are stored sequentially
%  info     -  A 1x4 vector where info=[#positive bags in training set, #negative bags in training set, #positive bags in testing set, #negative bags in training set]



    %import preprocessed Musk1 data
	all=importdata(strcat(curdir,'\all.txt'));
	molecule_num=importdata(strcat(curdir,'\molecule_num.txt'));    
    
	mole_num=92;
	pos=47;
	neg=45;
	instances=sum(molecule_num);
	pos_instances=sum(molecule_num(1:pos));
	neg_instances=instances-pos_instances;
	dim=166;
	
	pos_fold=[5 5 5 5 5 5 5 4 4 4];
	neg_fold=[5 5 5 5 5 4 4 4 4 4];
	
	rand('state',sum(100*clock));
	per_pos=randperm(pos);
	rand('state',sum(100*clock));
	per_neg=randperm(neg);
	
	
	matfiles=strcat(curdir,'\permutations.mat');
	save(matfiles,'per_pos','per_neg');            
	
	for fold=1:10
        test_pos=pos_fold(fold);
        test_neg=neg_fold(fold);
        train_pos=pos-test_pos;
        train_neg=neg-test_neg;
        info=[train_pos,train_neg,test_pos,test_neg];
        
        trainIn=[];
        trainOut=[];
        testIn=[];
        testOut=[];
        for i=1:sum(pos_fold(1:(fold-1)))
            cur_mole=per_pos(i);
            base_pointer=sum(molecule_num(1:(cur_mole-1)));
            trainIn=[trainIn;all((base_pointer+1):(base_pointer+molecule_num(cur_mole)),:)];
            trainOut=[trainOut,molecule_num(cur_mole)];
        end
        
        for i=1:pos_fold(fold)
            cur_mole=per_pos(sum(pos_fold(1:(fold-1)))+i);
            base_pointer=sum(molecule_num(1:(cur_mole-1)));
            testIn=[testIn;all((base_pointer+1):(base_pointer+molecule_num(cur_mole)),:)];
            testOut=[testOut,molecule_num(cur_mole)];
        end
        
        for i=1:(sum(pos_fold)-sum(pos_fold(1:fold)))
            cur_mole=per_pos(sum(pos_fold(1:fold))+i);
            base_pointer=sum(molecule_num(1:(cur_mole-1)));
            trainIn=[trainIn;all((base_pointer+1):(base_pointer+molecule_num(cur_mole)),:)];
            trainOut=[trainOut,molecule_num(cur_mole)];
        end
        
        for i=1:sum(neg_fold(1:(fold-1)))
            cur_mole=per_neg(i);
            base_pointer=sum(molecule_num(1:(pos+cur_mole-1)));
            trainIn=[trainIn;all((base_pointer+1):(base_pointer+molecule_num(pos+cur_mole)),:)];
            trainOut=[trainOut,molecule_num(pos+cur_mole)];
        end        
            
        for i=1:neg_fold(fold)
            cur_mole=per_neg(sum(neg_fold(1:(fold-1)))+i);
            base_pointer=sum(molecule_num(1:(pos+cur_mole-1)));
            testIn=[testIn;all((base_pointer+1):(base_pointer+molecule_num(pos+cur_mole)),:)];
            testOut=[testOut,molecule_num(pos+cur_mole)];
        end        
            
        for i=1:(sum(neg_fold)-sum(neg_fold(1:fold)))
            cur_mole=per_neg(sum(neg_fold(1:fold))+i);
            base_pointer=sum(molecule_num(1:(pos+cur_mole-1)));
            trainIn=[trainIn;all((base_pointer+1):(base_pointer+molecule_num(pos+cur_mole)),:)];
            trainOut=[trainOut,molecule_num(pos+cur_mole)];
        end        
            
        mkdir(curdir,num2str(fold));
        save(strcat(curdir,'\',num2str(fold),'\trainIn.txt'),'trainIn','-ascii');
        save(strcat(curdir,'\',num2str(fold),'\testIn.txt'),'testIn','-ascii');
        save(strcat(curdir,'\',num2str(fold),'\trainOut.txt'),'trainOut','-ascii');
        save(strcat(curdir,'\',num2str(fold),'\testOut.txt'),'testOut','-ascii');
        save(strcat(curdir,'\',num2str(fold),'\info.txt'),'info','-ascii');
	end