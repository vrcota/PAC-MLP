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

%% loading the current all input costruction and allLabels. Then, I select only the day 1 for all the animals

% X = allfrequencyPoints;
% X = allfrequencyRanges;
% X = allHalfComodulograms;
% X = allComodulograms;

selection = [];
for i = 1:10
    selection = [selection (479*5*(i-1))+(1:479)]; % selection all animals day 1
end
X = X(:, selection);
labels = allLabels(selection);

hidnumbers = [3:1:49 50:2:98 100:5:195 200:10:490 500:25:800]; % per full comodulogram
% hidnumbers = [3:1:49 50:2:98 100:5:195 200:10:400]; % per half comodulogram
% hidnumbers = 3:6; % per points e ranges

n_proof = 10;

% initializations

wk = zeros(n_proof, numel(hidnumbers));
sws = wk;
rem = wk;
all = wk;

%% Coneversion to ones 
 
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

%% train/test split 30/70

[trainInd, ~, testInd] = dividerand(size(X,2), 0.7,0, 0.3);

%Train
Xtr = X(:, trainInd);
Xtr=Xtr';
Ntr = size(Xtr, 1);
Ytr_class_ones = Y_class_ones(:,trainInd);

%Test
Xts = X(:, testInd);
Xts=Xts';
Nts = size(Xts, 1);
Yts_class_ones = Y_class_ones(:,testInd);

%% Neural NetworK
            
for i_proof = 1:n_proof
    for Nhid = 1:numel(hidnumbers)
        net = patternnet(hidnumbers(Nhid)); % create a net with a desired number of hidden neurons
        net_tr_i{Nhid} = train(net, Xtr', Ytr_class_ones); % train
        net1 = net_tr_i{Nhid};
        Yts_pred = net1(Xts'); % test                  
        [tpr, fpr, ~] = roc(Yts_class_ones,Yts_pred);
        matrix_net{Nhid, i_proof} = net1; % store all the networks
                                
        for cl = 1:Nclass
            aucHide(Nhid,cl) = sum(tpr{cl}(1:end-1).*diff(fpr{cl})); 
        end
                                
    end

    rem(i_proof,:) = aucHide(:,1)';
    wk(i_proof,:) = aucHide(:,2)';
    sws(i_proof,:) = aucHide(:,3)';
                                  
end    

all = (wk + sws + rem)/3;
