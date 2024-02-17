function  [particles,localBest,localBestParticles,globalBest,globalBestParticle]=STF3BPSOSelection(L,L_t,NewU,PseudoLabels_KNN)
%% 
%% Initialize parameters
PopSize=30;
localBestParticles = zeros(PopSize,size(NewU,1));
globalBestParticle = zeros(size(NewU,1),1);
velocity = zeros(PopSize,size(NewU,1));
%% PSO Initialization
[Z,particles,localBest,globalBest]=STF3BPSO_Initialization(NewU,PopSize);
%% PSO FindMaxFit
[particles,localBest,localBestParticles,globalBest,globalBestParticle]=STF3BPSO_FindMaxFit(L,L_t,NewU,PseudoLabels_KNN,particles,Z,PopSize,localBest,localBestParticles,globalBest,globalBestParticle);
end

