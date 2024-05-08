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

function allLabels = labelsVector(path)
% it put together all the labels (each animal and each day of recording)
% after conversion to the 30 s no overlap format (5760 ---> 479 samples)
%
% the matrix is structured as follows: one animal one day is 479 and
% first all the days related to an animal are concated and then
% all these blocks are concatenated as well. It results into a vector 
% 479*ndays*animals elements long.

N_animals = 10;
N_days = 5;

allLabels = [];

for i = 1:N_animals

    animals = dir(path);
    animals(ismember({animals.name},{'.','..'})) = [];
    animal_path = fullfile(path, animals(i).name, animals(i).name); 
 
    for j = 1:N_days
        
        days = dir(animal_path);
        days(ismember({days.name},{'.','..'})) = [];
        tmp = load(fullfile(animal_path, days(j).name, 'labels.mat'));
        tmp = tmp.labels;

        % conversion

            % number of groups
            num_gruppi = length(tmp) / 12;
            
            % Inizialization
            vettore_raggruppato = zeros(1, num_gruppi);
            
            % grouping
            for ii = 1:num_gruppi
                gruppo = tmp((ii-1)*12 + 1 : ii*12);
                vettore_raggruppato(ii) = mode(gruppo);
            end
            
            
            vettore_raggruppato = vettore_raggruppato';
            tmp = vettore_raggruppato(1:479);

        allLabels = [allLabels; tmp];

    end
end

end