function [L,t]=STF3BPSO(label_x,label_x_t,unlabel_x)
%% The input paramters of the alogrithm
L=label_x;                 %已标记数据
U=unlabel_x;               %未标记数据
t=label_x_t;              %已标记数据的类别
count=1;                   %迭代次数
%% Parameters in the iterative proces
record_size_U=[];
record_size_U(count)=size(U,1);
%% Iterative self-labeling process
while 1
    fprintf('------------------------------Iterations of ST-FBBPSO:%g----------------------------\n',count)
    %% 初始化U
    newU=U;        
    %%
    PseudoLabels_KNN=DecisionForestClassifier(L,t,newU);
    [particles,localBest,localBestParticles,globalBest,globalBestParticle]=STF3BPSOSelection(L,t,newU,PseudoLabels_KNN);
    TempPos1=find(globalBestParticle==1);
    TempPos2=find(globalBestParticle==0);
    %%
    classifyU=newU(TempPos1,:);
    Pre=PseudoLabels_KNN(TempPos1);
    %%
    fprintf('--------------高置信度无标记样本数目:%g\n', size(classifyU,1))
    fprintf('--------------U集样本数%g,训练集总样本为%g\n',size(U,1),size(L,1));
    %% 更新L和U
    L=[L;classifyU];
    t=[t;Pre];
    U=newU(TempPos2,:);
    count=count+1;
    %% 判断停止条件
    record_size_U(count)=size(U,1);
    if (count>3 && isequal(record_size_U(count),record_size_U(count-1),record_size_U(count-2)))  ||  size(U,1)==0
        break;
    end
end
end
%%
