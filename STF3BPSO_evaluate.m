function fitnessValue = BBPSO_evaluate(L,L_t,newU,PseudoLabels_KNN,particles,Z,particles_ID)
%% 初始化训练集和测试集
TestSet=L;
TestSet_Label=L_t;
TrainingSet=L;
TrainingSet_Label=L_t;
for i=1:size(newU)
    if Z(particles_ID,i)==1
       TrainingSet=[TrainingSet;newU(i,:)];
       TrainingSet_Label=[TrainingSet_Label;PseudoLabels_KNN(i)];
    end
 end
%% 计算适应度值
%KNN = ClassificationKNN.fit(TrainingSet,TrainingSet_Label,'NumNeighbors',3);
%Predict_label=predict(KNN, TestSet);   
Predict_label=DecisionForestClassifier(TrainingSet,TrainingSet_Label,TestSet);
Acc=sum(TestSet_Label==Predict_label)/size(TestSet_Label,1);
fitnessValue=Acc;
end

