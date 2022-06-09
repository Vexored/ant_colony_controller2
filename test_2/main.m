%Fichier main pour l'algorithme d'optimisation.
%Essaie de différent paramètres pour a tf1 du bac d'eau
clc;
clear all;
close all;

%Pool 
%12 = nombres de coeurs;


%Les alpha
alpha = linspace(0.1,2,20);

%Les beta
beta = linspace(0.1, 2, 20);

%Les ponderation.
roh = linspace(0.1, 1, 10);

%Reglage algo
algo_iteration = 15;
algo_fourmis = 30;

nb_noeuds = 1000;

borne_inferieur = [0.1 0.5 0.1]; %Borne inférieur
borne_superieur = [5 10 0.8]; %Borne supérieur

nb_iteration = length(roh)*length(alpha)*length(beta);
iteration = 1;

data = struct('nb_fourmi', {1},'nb_iteration', {1},'nb_noeuds', {1},'borne_inferieur', {1},'borne_superieur',{1} , 'simulation',[] , 'temps', {1});
simulation = struct('iteration', cell(1,nb_iteration), 'roh', cell(1,nb_iteration), 'alpha',cell(1,nb_iteration), 'beta',cell(1,nb_iteration), 'as', cell(1,nb_iteration), 'temps', cell(1,nb_iteration));

data.nb_fourmi = algo_fourmis;
data.nb_iteration = algo_iteration;
data.nb_noeuds = nb_noeuds;
data.borne_inferieur = borne_inferieur;
data.borne_superieur = borne_superieur;

mat_cout = zeros(length(alpha),length(beta),length(roh));

start_tic = tic;
for R = 1:length(roh)
    for A = 1:length(alpha)
        for B = 1:length(beta)
            sim = struct('test', cell(1,12), 'cout', cell(1,12), 'mat_cout', cell(1,12),'pid',cell(1,12), 'temps',cell(1,12));
            start2_tic = tic;
            disp(['Simulation n°', num2str(iteration), ' / ', num2str(nb_iteration),': En cours...']);
            disp(['Paramètres: Roh: ', num2str(roh(R)), ' Alpha: ', num2str(alpha(A)),' Beta: ', num2str(beta(B))])

            parfor Test = 1:1
                start3_tic = tic;
                [cout, mat_cout, pid] = main_as_test(algo_iteration, algo_fourmis, nb_noeuds, roh(R), alpha(A), beta(B), borne_superieur, borne_inferieur);
                mat_cout(A ,B, R) = cout;
                sim(Test).test = Test;
                sim(Test).cout = cout;
                sim(Test).mat_cout = mat_cout;
                sim(Test).pid = pid;
                sim(Test).temps = toc(start3_tic);
            disp(['Test n°', num2str(Test), ': Cout: ', num2str(cout), ' Temps: ', num2str(sim(Test).temps), 's ## Paramètres PID: P: ', num2str(sim(Test).pid(algo_iteration,1)), ' I: ', num2str(sim(Test).pid(algo_iteration,2)),' D: ', num2str(sim(Test).pid(algo_iteration,3))])
            end
            disp(' ')
            simulation(iteration).iteration = iteration;
            simulation(iteration).roh = roh(R);
            simulation(iteration).alpha = alpha(A);
            simulation(iteration).beta = beta(B);
            simulation(iteration).as = sim;
            simulation(iteration).temps = toc(start2_tic);
            iteration = iteration + 1;
       end
    end
end

data.simulation = simulation;
data.temps = toc(start_tic);

save('data.mat', 'data');
save('mat_cout.mat', 'mat_cout');
