function [L,t]=STF3BPSO(label_x,label_x_t,unlabel_x)
%% The input paramters of the alogrithm
L=label_x;                 %�ѱ������
U=unlabel_x;               %δ�������
t=label_x_t;              %�ѱ�����ݵ����
count=1;                   %��������
%% Parameters in the iterative proces
record_size_U=[];
record_size_U(count)=size(U,1);
%% Iterative self-labeling process
while 1
    fprintf('------------------------------Iterations of ST-FBBPSO:%g----------------------------\n',count)
    %% ��ʼ��U
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
    fprintf('--------------�����Ŷ��ޱ��������Ŀ:%g\n', size(classifyU,1))
    fprintf('--------------U��������%g,ѵ����������Ϊ%g\n',size(U,1),size(L,1));
    %% ����L��U
    L=[L;classifyU];
    t=[t;Pre];
    U=newU(TempPos2,:);
    count=count+1;
    %% �ж�ֹͣ����
    record_size_U(count)=size(U,1);
    if (count>3 && isequal(record_size_U(count),record_size_U(count-1),record_size_U(count-2)))  ||  size(U,1)==0
        break;
    end
end
end
%%
