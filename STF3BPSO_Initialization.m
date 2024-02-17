function [Z,particles,localBest,globalBest]=STF3BPSO_Initialization(NewU,PopSize)
%%
% DPC的初始化策略
%%
particles=zeros(PopSize,size(NewU,1)); % particles 
Z=zeros(PopSize,size(NewU,1));
localBest=zeros(PopSize,1); %best position so far of each particle given as fitness 
globalBest=0; % best position so far of the entire swarm given as fitness 
%% 初始化PopSize个群体，其中每个群体都是原始样本的一个子集，particles是子集的指示函数
for i = 1: PopSize
    for j=1:size(NewU,1)
        if rand()>=0.5
            particles(i,j) = 1;
            Z(i,j)=1;
        else
            particles(i,j) = 0;
            Z(i,j)=0;
        end
    end
end
%% initiate globalBest and localBest
for i=1: PopSize
    localBest(i) = -Inf;
end
globalBest = -Inf;
end

