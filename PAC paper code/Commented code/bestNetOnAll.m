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

function best_net = bestNetOnAll(all, matrix_net, Xts, Yts_class_ones, savepath, type)
% select the best-performing network and plots the ROC curves for it

Nclass = 3;

[~, ind] = max(all', [], "all"); % it takes the transposition since all and matrix_net have a nhid/proof transposed organization
matrix_net = matrix_net(:);  
best_net = matrix_net{ind};


Yts_pred = best_net(Xts');

fig = figure("Color",'w');
plotroc(Yts_class_ones, Yts_pred)
set(gcf, 'Position', [0 0 500 500], "Color", 'w')


[tpr, fpr, ~] = roc(Yts_class_ones,Yts_pred);                              
for cl = 1:Nclass
    auc(cl) = sum(tpr{cl}(1:end-1).*diff(fpr{cl})); 
end



legend(["" strcat("REM, AUC = ", string(auc(1))) "" strcat("WK, AUC = ", string(auc(2))) "" strcat("SWS, AUC = ", string(auc(3)))])

set(gca, 'FontName', 'Arial')

figname = strcat('figure_2_rocs_', string(type));
fignamesvg = strcat('figure_2_rocs_', string(type), '.svg');
savefig(fig, fullfile(savepath, figname));
saveas(fig, fullfile(savepath, fignamesvg));

close gcf

end