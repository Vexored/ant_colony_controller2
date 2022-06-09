% Cout suivant Alpha, Beta, pour une ponderation choisit
%% Clean Workspace
clear all;
clc;

%% Lecture des données
load('mat_cout.mat');
load('data.mat');
%%
a = 1;
b = 1;
for i = 2401:2800 %Choix ponderation Ici roh = 0.7
        if(b == 21)
            a = a + 1;
            b = 1;
        end
    MyMatrix = vertcat(data.simulation(i).as(1:12).cout);
    matrice_cout(a,b) = min(MyMatrix);
        b = b + 1;
end
surf(matrice_cout)
xlabel('Beta')
ylabel('Alpha')
zlabel('Cout minimal pour 12test')
