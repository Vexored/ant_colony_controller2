%D'après l'algorithme de Mr.Ammar Al-Jodah
%Il s'agit d'un algorithme AS un peu bizarre

%% Paramètres de la colonies de fourmi

nb_iteration = ; %Nombre d'itération
nb_fourmi = ; %Nombre de fourmis

% Paramètre de pondération de la colonie

alpha = ;
beta = ;
roh = ; % Coefficient d'évaporation des phéromones

% Paramètres pour la recherche des coefficients du PID

nb_param = 3; %Nombre de paramètres -> P I D

%Ici, on borne la valeur des coefficients possibles
borne_inferieur = [0 0 0]; %Borne inférieur
borne_superieur = [ 0 0 0]; %Borne supérieur

%Précision voulu pour les coefficients
nb_noeud = ; % Plus le nombre de noeuds est élevé, plus la précision est grande

%% Initialisation des matrices et des variables internes

mat_fourmis = zeros(nb_fourmi, nb_param); %Permet de savoir "l'étape" des fourmis

mat_noeuds = zeros(nb_noeud, nb_param); %Création de la "carte"
mat_chemin = zeros(1, nb_param); %Matrice pour récupéré les noeuds emprunté par la fourmis
mat_proba = zeros(nb_noeud, nb_param); %Probabilité d'emprunter chaque noeuds.

%Matrice phéromones
mat_phero = zeros(nb_noeud, nb_param); %Matrice des phéromones
mat_phero_Calcul = zeros(nb_noeuds, nb_param); %Matrice de calcul des phéromones déposés
%Couts des chemins A VOIR PLUS TARS
mat_cout = zeros(nb_fourmi, 1);
meilleur_cout_ind = ;
meilleur_cout_prev = ;
meilleur_cout = ;

pire_cout = ;
pire_cout_ind = ;
pire_cout_prev = ;

%% Initialisation de l'algorithme

%Generation des noeuds
for i = 1:nb_param % A parallélisé en THREAD
    mat_noeuds(:,i) = linspace(borne_inferieur(i), borne_superieur(i), nb_noeud);
end

%Génération et initialisation des phéromones
mat_phero = ones(nb_noeud, nb_param).*eps; %Initialisation de la part de l'auteur un peu bizarre

%% Calcul des itérations

for iteration = 1:nb_iteration

    %Calcul de la probabilité d'emprunter chaque noeud -- A TESTER UN AUTRE
    %CALUL
    for param_i = 1:nb_param % A parralélisé en THREAD
        mat_proba(:,param_i) = (mat_phero(:,param_i).^alpha).*((1./mat_noeuds(:,param_i)).^beta);
        mat_proba(:,param_i) = mat_proba(:,param_i)./sum(prob(:,param_i));
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
        FONCTION
        %
        disp(['Fourmi n°: ' num2str(A)])
        disp(['Cout du chemin: ' num2str(cost(A))])
        disp(['Paramètre PID: ' num2str(mat_chemin)])
        disp(['Iteration: ' num2str(iter)])

        if iter~=1
            disp('_________________')
            disp(['Meilleur chemin: ' num2str(cost_best)])

            for param_i=1:nb_param
                mat_chemin(param_i) = mat_noeuds(mat_fourmis(meilleur))
            end
            disp(['Mailleur parametres: ' num2str(mat_chemin])
        end

    end

    [meilleur_cout, meilleur_cout_ind] = min(mat_cout);

    %Election de la meilleur fourmi
    if( meilleur_cout < meilleur_cout_prev) && (iter~=1)
        [pire_cout, pire_cout_ind] = max(cout);
        mat_fourmis(pire_cout_ind, :) = m

        %Modification de la matrice des phéromones

    end
end







