function cost_value=costFunction3(k,sys)

K_retour = place(sys.A, sys.B, k)
N_retour = 1/(sys.C*inv(-sys.A+sys.B*K_retour)*sys.B);
sys_BF = feedback(sys, K_retour, -1);
sys_BF = N_retour*sys_BF;

t = linspace(0,20,50000);
[y temps] = step(sys_BF*ref,t);
tic
err=ref-y;
[n,~]=size(err);
cost_value=0;
for i=1:n
    % cost_value=cost_value+(err(i))^2 ;  % ISE
    % cost_value=cost_value+abs(err(i));  % IAE
    cost_value=cost_value+temps(i)*abs(err(i));  % ITAE
     %cost_value=cost_value+temps(i)*(err(i))^2;  % MSE
end
%   cost_value=cost_value/temps(n);  % MSE

end
%Gain precompensation et retour d'état
% poles_des = [-2.4+5.5i -2.4-5.5i]
% K_retour = acker(A, B, poles_des)
% N_retour = 1/(C*inv(-A+B*K_retour)*B)
%Converge en 1.5s