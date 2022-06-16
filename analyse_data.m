% Objectif 
% Analyser les données et classer les pid en deux catégorie.
% Des courbes amortie et des courbes oscillante.
%clear all;
%load("../../../data.mat");

% On choisit la simulation 
%i = 2949;
%i= 2545;
i = 1;
depassement = 105;

mat_pid_ok = zeros(length(data.simulation));
            disp(['Analyse n°', num2str(i)]);
alpha = data.simulation(i).alpha;
beta = data.simulation(i). beta;
roh = data.simulation(i).roh;


%On calcul les réponses indicielles
systeme = tf(1.822,[8.569, 1]);
for i_sim = 1:length(data.simulation(i).as)
    matpid(:,i_sim) = data.simulation(i).as(i_sim).pid(length(data.simulation(i).as(i_sim).pid),:);
end
C = pid(matpid(1,:), matpid(2,:), matpid(3,:));
BF = feedback(C*systeme, 1);
t = linspace(0,50,100000);
for i_sim = 1:length(data.simulation(i).as)
    [y(:,i_sim), ~] = step(BF(:,:,1,i_sim)*100,t);
    [y_max(i_sim, 1), y_max(i_sim, 2)] = max(y(:,i_sim));
end

%Afficher le step générale
figure('name', 'Step des i tests');
step(BF*100);

%Afficher les fonctions catégorisés
figure('Name', 'Step catégorisé');
hold on;
grid on;
for i_sim = 1:length(data.simulation(i).as)
    if(y_max(i_sim,1) > depassement) %En rouge les réponses oscillant
        plot(t,y(:,i_sim), 'r');
    else
        mat_pid_ok(i) = mat_pid_ok(i) + 1;
        plot(t,y(:,i_sim),'b'); %En bleu les réponses armoties
    end
end

