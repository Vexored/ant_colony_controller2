function [cost_value,mat_cout_I,  param_mat] = main_as_test(nb_iteration, nb_fourmi, nb_noeud, roh, alpha, beta, borne_inferieur, borne_superieur)

nb_param = 3; %Nombre de paramètres -> P I D

%% Initialisation des matrices et des variables internes

mat_fourmis = zeros(nb_fourmi, nb_param); %Permet de savoir "l'étape" des fourmis

mat_noeuds = zeros(nb_noeud, nb_param); %Création de la "carte"
mat_chemin = zeros(1, nb_param); %Matrice pour récupéré les noeuds emprunté par la fourmis
mat_proba = zeros(nb_noeud, nb_param); %Probabilité d'emprunter chaque noeuds.
param_mat = zeros(nb_iteration,nb_param);

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
        mat_cout_F(fourmi) = costFunction3(mat_chemin);

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

    param_mat(iteration,:) = mat_chemin;

end
cost_value = meilleur_cout;
end
