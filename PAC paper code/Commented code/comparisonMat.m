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

function mat = comparisonMat(X, labels, savepath)
% X comprises all the animals all the days (already normalized), look at
% comodulogramsMat.m.
% labels follows the same logic, look at labelsVector.m.
%
% The function gives back a matrix containing average auc values from WK,
% SWS and REM classification. Each entry is the result of the network
% trained with the animal with the ID corresponding to the row index tested against the
% animal corresponding to the column index

% parameters
N_animals = 10; % number of animals
N_days = 5; % number of days

%% creation of the networks corresponding to each animal

    % Creazione di labels di uni
     
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

    for animal = 1 : N_animals

        X_anim = X(:, ((animal-1)*479*N_days + 1):(animal)*479*N_days); % taking all the days regarding an animal
        Y_class_ones_anim = Y_class_ones(:, ((animal-1)*479*N_days + 1):(animal)*479*N_days);

        % train/test split 30/70
        
        [trainInd, ~, testInd] = dividerand(size(X_anim,2), 0.7,0, 0.3);
        
        %Train
        Xtr = X_anim(:, trainInd);
        Xtr=Xtr';
        Ntr = size(Xtr, 1);
        Ytr_class_ones_anim = Y_class_ones_anim(:,trainInd);
        
        %Test
        Xts = X_anim(:, testInd);
        Xts=Xts';
        Nts = size(Xts, 1);
        Yts_class_ones_anim = Y_class_ones_anim(:,testInd);
        
    
        n_proof = 10;
        n_hid = 15;

        matrix_net = {};
        rem = [];
        sws = [];
        wk = [];
        all = [];
        aucHide = [];
                    
        for i_proof = 1:n_proof
            
                net = patternnet(n_hid); % creating a net with a desired number of hiddden neurons
                net_tr_i = train(net, Xtr', Ytr_class_ones_anim); % training
                net1 = net_tr_i;
                Yts_pred = net1(Xts'); % test                    
                [tpr, fpr, ~] = roc(Yts_class_ones_anim,Yts_pred);
                matrix_net{i_proof} = net1; % storing all the nets
                                        
                for cl = 1:Nclass
                    aucHide(cl) = sum(tpr{cl}(1:end-1).*diff(fpr{cl}));
                end

                rem(i_proof) = aucHide(1)';
                wk(i_proof) = aucHide(2)';
                sws(i_proof) = aucHide(3)';                
                                    
        end    
        
        all = (wk + sws + rem)/3;
        [~, ind] = max(all);
        best_nets{animal} = matrix_net{ind}; % selecting the best-performing network

    end

%% mat 

    % initialization

    mat = zeros(N_animals);

    % cycling over the train and the test animal to produce mat

    for trainan = 1:N_animals

        for testan = 1:N_animals

            Xnew = X(:, ((testan-1)*479*N_days + 1):(testan)*479*N_days);
            Ynew_class_ones = Y_class_ones(:, ((testan-1)*479*N_days + 1):(testan)*479*N_days);
            an_net = best_nets{trainan};
            Ynew_pred = an_net(Xnew);  
            [tpr, fpr, ~] = roc(Ynew_class_ones,Ynew_pred);
                                  
            for cl = 1:Nclass
                aucHide(cl) = sum(tpr{cl}(1:end-1).*diff(fpr{cl}));
            end

            mat(trainan, testan) = mean(aucHide);

        end
        
    end



%% plot

fig = figure("Color",'w');
image(mat,'CDataMapping','scaled')
colormap("hot") % or "sky"
colorbar
clim([0.95 1])
box off
xlabel("Test animal")
ylabel("Train animal")
title("");
% xlim();
% ylim();
% legend()
set(gca, 'FontName', 'Arial')
figname = 'comparison';
fignamesvg = 'comparison.svg';
savefig(fig, fullfile(savepath, figname));
saveas(fig, fullfile(savepath, fignamesvg));

close gcf

end