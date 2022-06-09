%Fichier main pour l'algorithme d'optimisation.
%Essaie de différent paramètres pour a tf1 du bac d'eau
clc;
clear all;
close all;

%Les alpha
alpha = linspace(0.01,10,1000);

%Les beta
beta = linspace(0.01, 10, 1000);

%Les ponderation.
roh = linspace(0.01, 1, 10);

iteration = 100;
fourmis = 30;

nb_test = size(alpha,2)*size(beta,2)*size(roh,2);
nb_test_a = 0;
mat_cout = zeros(size(roh,2), size(alpha,2), size(beta,2));
roh_count = 0;
alpha_count = 0;
beta_count = 0;
parfor R = 1:10
    %roh_count = roh_count + 1;
    for A = 1:100
        %alpha_count = alpha_count + 1;
        for B = 1:100
            %beta_count = beta_count + 1;
            %nb_test_a = nb_test_a + 1;
            %disp(['Test n°: ' num2str(nb_test_a)])
            mat_cout(R, A ,B) = main_as_test(iteration, fourmis, roh(R), alpha(A), beta(B));
            %disp(['Meilleur Chemin: ' num2str(mat_cout(roh_count, alpha_count ,beta_count))]);
        end
    end
end
save('mat__cout.mat', 'mat_cout');