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

function allComodulograms = comodulogramsMat(path)
% it puts together data from all animals, all days, it does also the normalization (zscore)

allComodulograms = [];

elements = dir(path);
elements(ismember({elements.name},{'.','..'})) = [];
elements = [elements(6:50); elements(1:5)]; % sorting

for j = 1:numel(elements)
    element = load(fullfile(path, elements(j).name)); 
    element = element.comodulogrammi;

    % initialization
    vettori_colonna = cell(1, numel(element));                            
    
    % concatenation of all the comodulograms as columns
    for i = 1:numel(element)
        matrice = element{i}; % current comodulogram
        
        % reshaping into column
        vettori_colonna{i} = matrice(:);
    end
    
    % initialization of the all columns concatenation vector
    vettore_unico = [];
    
    % Iteration
    for i = 1:numel(vettori_colonna)
        cella_corrente = vettori_colonna{i};
        
        % reshaping
        vettore_colonna = reshape(cella_corrente, [], 1);
        
        % Concatenation
        vettore_unico = [vettore_unico; vettore_colonna];
    end

    % final matrix 
    matrice_finale = zeros(800, length(element));
    for i = 1:length(element)
        matrice_finale(:, i) = vettori_colonna{i}(:);
    end 

    % zscore
    standardized = true;
    if standardized
        matrice_finale = zscore(matrice_finale);
    end

    allComodulograms = [allComodulograms matrice_finale];

end

end