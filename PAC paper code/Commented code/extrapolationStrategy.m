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

function [labels, X] = extrapolationStrategy(allLabels, allComodulograms, mode)
% resampling of the whole dataset according to the extrapolation strategy

ndays = 5;
nanimals = 10;

if mode == "all"

    labels = allLabels;
    X = allComodulograms;

elseif mode == "allM_D1"
    
    labels = [];
    X = [];
    for i = 1:nanimals
        labels = [labels allLabels((1:479)+(479*(nanimals-1)))];
        X = [X allComodulograms(:, (1:479)*(nanimals-1))];
    end

elseif mode == "allD_M1"

    labels = allLabels(1:479*ndays);
    X = allComodulograms(:,1:479*ndays);

elseif mode == "M1D1"

    labels = allLabels(1:479);
    X = allComodulograms(:,1:479);

end

end