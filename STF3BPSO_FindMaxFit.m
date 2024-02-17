function [particles,localBest,localBestParticles,globalBest,globalBestParticle]=STF3BPSO_FindMaxFit(L,L_t,NewU,PseudoLabels_KNN,particles,Z,PopSize,localBest,localBestParticles,globalBest,globalBestParticle)
%% Descriptions for retuned values
% localBest: 每个粒子的最好位置的适应度值
% localBestParticles: 每个粒子的最好位置
% globalBest: 全局最好粒子的位置的适应度值
% globalBestParticle:  全局最好粒子的位置
% particles: 粒子群
D=length(PseudoLabels_KNN);
iteration=999;
IterativeglobalBest=zeros(1,iteration);
Mask=zeros(1,D);
%% perform optimization process
i=1;
for i=1:iteration
    fprintf('--------------------Iterations of FBBPSO: %g---------------------\n',i)
    fprintf('--localBest     Fitness==1:%g/%g &&& globalBest: %g \n',length(find(localBest==1)),length(localBest),globalBest);
    for j=1:PopSize
%% (1) evaluate the fitness of a given particle
        particles_ID=j;
        fitness= STF3BPSO_evaluate(L,L_t,NewU,PseudoLabels_KNN,particles,Z,particles_ID);
%% (2) update local values
        if localBest(j) < fitness
			localBestParticles(j,:) = Z(j,:);
			localBest(j)= fitness;		
        end     
%% (3) update global values
        if globalBest < fitness
            globalBestParticle = Z(j,:);
            globalBest = fitness;
        end	
    end
%% (4) update each particle's  position by the bare bones strategy
    for j=1:PopSize
        pos=find(Mask==0);
        for k=1:length(pos)
            MU=0.5*(localBestParticles(j,pos(k))+globalBestParticle(pos(k)));
            SIGMA=abs(localBestParticles(j,pos(k))-globalBestParticle(pos(k)));
            particles(j,pos(k)) =normrnd(MU,SIGMA);
        end
        for k=1:length(pos)
             if particles(j,pos(k))>=rand
                 Z(j,pos(k))=1;
             else
                 Z(j,pos(k))=0;
             end
        end
    end
%% 计算Masks
    for j=1:D
        MaskProb=sum(localBestParticles(:,j))/PopSize;
        RandomNum=rand();
%%     如果大多数最好粒子选择了这个样本，
%       if MaskProb>=RandomNum    
%          Mask(j)=0;
%       end
 %%  Condition 1: 如果大多数最好粒子没有选择这个样本，那么这个样本也可能是Pseudo Labels Noise
 %%  Condition 2: if PseudoLabels_SSFCM !=PseudoLabels_KNN，那么这个样本也可能是Pseudo Labels Noise
        if MaskProb<RandomNum
            Mask(j)=1;
            Z(:,j)=0;
        end 
    end
    IterativeglobalBest(i)=globalBest;
    if globalBest==1 || (i>4 && isequal(IterativeglobalBest(i),IterativeglobalBest(i-1),IterativeglobalBest(i-2),IterativeglobalBest(i-3)))
        break
    end
end
end

