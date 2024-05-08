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

%% Unless this first section which is used to apply a certain extrapolation strategy, this script follows the same rationale of figure2_retetrain.m.
% look at it for a commented version of the code

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X = allHalfComodulograms;
labels = allLabels;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % trainselection = [];  % figure 3 sampling
            % testselection = [];
            % rng(42);
            % trainsampling = randperm(479, 335);
            % testsampling = setdiff(1:479, trainsampling);
            % for i = 1:50
            %     trainselection = [trainselection ((i-1)*479)+trainsampling];
            %     testselection = [testselection ((i-1)*479)+testsampling];
            % end
            % X = allHalfComodulograms(:, trainselection);
            % labels = allLabels(trainselection);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % selection = [];  
            % for i = 1:10
            %     selection = [selection (479*5*(i-1))+(1:479)]; % selezione per allMD1
            % end
            % 
            % X = X(:, selection);
            % labels = allLabels(selection);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            

% X = allHalfComodulograms(:, 1:5*479); % all days animal 1
% labels = allLabels(1:5*479);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% X = allHalfComodulograms(:, (6*5*479+1):(((6*5)+1)*479)); % d1 a7
% labels = allLabels((6*5*479+1):(((6*5)+1)*479));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% X = allHalfComodulograms(:, (9*5*479+1):(((9*5)+1)*479)); % d1 a7
% labels = allLabels((9*5*479+1):(((9*5)+1)*479)); % d1 a10

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

n_hid = 15;

n_proof = 10;

wk = zeros(n_proof, 1);
sws = wk;
rem = wk;
all = wk;

%% 
 
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

%% 

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
    
        net = patternnet(n_hid); 
        net_tr_i = train(net, Xtr', Ytr_class_ones); 
        net1 = net_tr_i;
        Yts_pred = net1(Xts');                   
        [tpr, fpr, ~] = roc(Yts_class_ones,Yts_pred);
        matrix_net{i_proof} = net1; 
                                
        for cl = 1:Nclass
            aucHide(cl) = sum(tpr{cl}(1:end-1).*diff(fpr{cl})); 
        end                        
   

    rem(i_proof) = aucHide(1)';
    wk(i_proof) = aucHide(2)';
    sws(i_proof) = aucHide(3)';
                
                            
end    

all = (wk + sws + rem)/3;

 