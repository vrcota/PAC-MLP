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

function aucs = fig3to6(X, labels, net)
% used to produce all the aucs requested for all the panels of figures 3,
% 4, 5, and 6. Note: uncomment the correct portion of code depending on the
% figure

ndays = 5;
nanimals = 10;
aucs = zeros(nanimals, ndays, 4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fig. 4, 5, and 6

% for i = 1:nanimals
%     for j = 1:ndays
%         tmp = ((i-1)*ndays + j-1)*479 + 1;
%         Xtemp = X(:, tmp:(tmp+478));
%         labelstemp = labels(tmp:(tmp+478));
%         aucs(i,j,:) = auctest(net, Xtemp, labelstemp);
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fig. 3

for i = 1:nanimals
    for j = 1:ndays
        tmp = ((i-1)*ndays + j-1)*144 + 1;
        Xtemp = X(:, tmp:(tmp+143));
        labelstemp = labels(tmp:(tmp+143));
        aucs(i,j,:) = auctest(net, Xtemp, labelstemp);
    end
end

end