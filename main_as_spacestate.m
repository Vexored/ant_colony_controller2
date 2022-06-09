function cost_value = main_as_test(nb_iteration,nb_fourmi, roh, alpha, beta)

%D'après l'algorithme de Mr.Ammar Al-Jodah
%Il s'agit d'un algorithme AS un peu bizarre

%% SS

S = 0.0154; %m^2
S_N = 5*10^(-5); %m^2 
k = 1.6*10^5;
b = -9.2592;
g = 9.81;

H_0 = [0.27474 0.0299 0.1368]';

a_13 = 0.4753*S_N*sqrt(2*g);
a_32 = 0.4833*S_N*sqrt(2*g);
a_20 = 0.9142*S_N*sqrt(2*g);
Q_10 = 3.5*10^(-5);
R_13 = sqrt(abs(H_0(1) - H_0(3)))/a_13;
R_20 = sqrt(abs(H_0(2)))/a_20;%Ne correspond a aucune H sauf que pas relier a un tuyau
R_32 = sqrt(abs(H_0(3) - H_0(2)))/a_32;

A = [-1/(S*R_13) 1/(S*R_13) 0; 1/(S*R_13) (-1/S)*((1/R_13) + (1/R_32)) 1/(S*R_32); 0 1/(S*R_32) (-1/S)*((1/R_32) + (1/R_20))];
B = [1/S; 0; 0];
C = [1 0 0];
D = [0];

sys = ss(A, B, C, D);

%% Paramètres de la colonies de fourmi
% 
 nb_iteration = 100; %Nombre d'itération
 nb_fourmi = 30; %Nombre de fourmis
% 
% Paramètre de pondération de la colonie
% 
 alpha = 0.8;
 beta = 0.2;
 roh = 0.55; % Coefficient d'évaporation des phéromones

% Paramètres pour la recherche des coefficients du PID
nb_param = 6; %Nombre de pol des./2
 
%création nombres complexes



%Ici, on borne la valeur des coefficients possibles
borne_inferieur = [0 -10 0 -10 0 -10]; %Borne inférieur
borne_superieur = [-20 10 -20 10 -20 10]; %Borne supérieur

%Précision voulu pour les coefficients
nb_noeud = 1000; % Plus le nombre de noeuds est élevé, plus la précision est grande

%% Initialisation des matrices et des variables internes

mat_fourmis = zeros(nb_fourmi, nb_param); %Permet de savoir "l'étape" des fourmis

mat_noeuds = zeros(nb_noeud, nb_param); %Création de la "carte"
mat_chemin = zeros(1, nb_param); %Matrice pour récupéré les noeuds emprunté par la fourmis
mat_proba = zeros(nb_noeud, nb_param); %Probabilité d'emprunter chaque noeuds.

%Matrice phéromones
mat_phero = zeros(nb_noeud, nb_param); %Matrice des phéromones
mat_phero_Calcul = zeros(nb_noeud, nb_param); %Matrice de calcul des phéromones déposés
%Couts des chemins A VOIR PLUS TARS
mat_cout_F = zeros(nb_fourmi, 1);
meilleur_cout_ind = inf;
meilleur_cout_prev = inf;
meilleur_cout = inf;

pire_cout = inf;
pire_cout_ind = inf;
pire_cout_prev = inf;

mat_cout_I = zeros(nb_iteration, 1);
%% Initialisation de l'algorithme

%Generation des noeuds
for i = 1:nb_param % A parallélisé en THREAD
    mat_noeuds(:,i) = linspace(borne_inferieur(i), borne_superieur(i), nb_noeud);
end

%Génération et initialisation des phéromones
mat_phero = ones(nb_noeud, nb_param).*eps; %Initialisation de la part de l'auteur un peu bizarre

%Flo
mat_nb_pid_find = zeros(nb_iteration, 3);
%nb_pid_find = 0;

%% Calcul des itérations
%figure('name', 'Cout Iteration');

for iteration = 1:nb_iteration

    %Calcul de la probabilité d'emprunter chaque noeud -- A TESTER UN AUTRE
    %CALUL
    for param_i = 1:nb_param % A parralélisé en THREAD
        mat_proba(:,param_i) = (mat_phero(:,param_i).^alpha).*((1./mat_noeuds(:,param_i)).^beta);
        mat_proba(:,param_i) = mat_proba(:,param_i)./sum(mat_proba(:,param_i));
    end

    %Calcul du chemin emprunté par chaque fourmi
    for fourmi = 1:nb_fourmi %A parralélisé en THREAD
        %Pour chaque paramètre
        for param_i = 1:nb_param
            %On choisit une proba au hasard
            proba_rand = rand;
            noeud_choisit = 1;
            proba_cumsum = 0;
            for noeud_j = 1:nb_noeud
                proba_cumsum = proba_cumsum + mat_proba(noeud_j, param_i); %RouletteWheelRandom
                if proba_cumsum >= proba_rand
                    noeud_choisit = noeud_j; %On selectionne le noeud pour la fourmi
                    break
                end
            end
            %On attribu le noeud a la fourmi et on enregistre le chemin
            %emprunter
            mat_fourmis(fourmi, param_i) = noeud_choisit;
            mat_chemin(param_i) = mat_noeuds(noeud_choisit, param_i);
        end
        % Calcul du cout du chemin emprunter
        K(1) = complex(mat_chemin(1), mat_chemin(2));
        K(2) = complex(mat_chemin(3), mat_chemin(4));
        K(3) = complex(mat_chemin(5), mat_chemin(6));

        mat_cout_F(fourmi) = costFunction3(K, sys);
        % Affichage des infos
        clc;
        disp(['Fourmi n°: ' num2str(fourmi)])
        disp(['Cout du chemin: ' num2str(mat_cout_F(fourmi))])
        disp(['Paramètre PID: ' num2str(mat_chemin)])
        disp(['Iteration: ' num2str(iteration)])

        if iteration~=1
            disp('_________________')
            disp(['Meilleur chemin: ' num2str(meilleur_cout)])

            for param_i=1:nb_param
                mat_chemin(param_i) = mat_noeuds(mat_fourmis(meilleur_cout_ind, param_i), param_i);
            end
            disp(['Meilleur parametres: ' num2str(mat_chemin)])
        end

    end

    [meilleur_cout, meilleur_cout_ind] = min(mat_cout_F);

    %Election de la meilleur fourmi
    if( meilleur_cout > meilleur_cout_prev) && (iteration~=1)
        [pire_cout, pire_cout_ind] = max(mat_cout_F);
        mat_fourmis(pire_cout_ind, :) = meilleur_fourmi_prev;
        meilleur_cout = meilleur_cout_prev;
        meilleur_cout_ind = pire_cout_ind;
    else
        meilleur_cout_prev = meilleur_cout;
        meilleur_fourmi_prev = mat_fourmis(meilleur_cout_ind,:);
        
    end
    %Modification de la matrice des phéromones
    mat_phero_Calcul = zeros(nb_noeud, nb_param);
    for param_i = 1:nb_param
        for fourmi = 1:nb_fourmi
            mat_phero_Calcul(mat_fourmis(fourmi, param_i), param_i) = mat_phero_Calcul(mat_fourmis(fourmi, param_i), param_i) + meilleur_cout/mat_cout_F(fourmi);
        end
    end
    mat_phero = roh.*mat_phero + mat_phero_Calcul;
    mat_cout_I(iteration)=meilleur_cout;
 
end
cost_value = meilleur_cout;

end
