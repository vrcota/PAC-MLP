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

function allfrequencyPoints = frequencypointsMat(path)

load(fullfile(path,"x1(day2to5).mat"));
load(fullfile(path,"x1day1.mat"));
load(fullfile(path,"Xfrom2to5.mat"));
load(fullfile(path,"Xfrom6to10.mat"))
MImouse1day1 = x1day1;
clear x1day1

clear path

list = who;
list = {list{6:50} list{1:5}};

allfrequencyPoints = [];

for i = 1:numel(list)

    allfrequencyPoints = [allfrequencyPoints eval(list{i})'];

end

standardized = true;
if standardized
    allfrequencyPoints = zscore(allfrequencyPoints);
end

end