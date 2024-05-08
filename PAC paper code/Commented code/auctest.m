% Efficient Sleep Stage Differentiation via Phase-Amplitude Coupling Pattern Classification
%
% Vinicius Rosa Cota1, Gianluca Federici2, Simone Del Corso2, Gabriele Arnulfo2, Michela Chiappalone1, 2
%
% 1 Rehab Technologies Lab, Istituto Italiano di Tecnologica, Via Morego 30, 16163, Genova, Italy
% 2 Department of Informatics, Bioengineering, Robotics, System Engineering (DIBRIS), University of Genova, Via all’Opera Pia 13, 16145, Genova, Italy
% 
% Neurocomputing journal
% 
% Corresponding author:
% vinicius.rosacota@iit.it
%
% 2024
%
% Copyright of authors
% This code is distributed under CC-BY-NC-SA license
% 
% This code is distributed AS IS and we do not warrant any kind of
% guarantees. Usage of this source code in any kind of applications
% is at the sole risk of the user. 

function aucs = auctest(net, X, labels)
% it gets the aucs values for all the sleep stages and their average

Yclass=labels;
t1 = (Yclass == 1);
t2 = (Yclass == 2);
t3 = (Yclass == 3);
t1=double(t1);
t2=double(t2);
t3=double(t3);
labels=[t1,t2,t3];
Y_class_ones = labels';

Nclass = 3;
Y_pred = net(X);

[tpr, fpr, ~] = roc(Y_class_ones,Y_pred);


for cl = 1:Nclass
    aucs(cl) = sum(tpr{cl}(1:end-1).*diff(fpr{cl}));  
end

aucs = [aucs mean(aucs)];

end