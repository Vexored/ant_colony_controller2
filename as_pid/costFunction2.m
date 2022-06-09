function cost_value=costFunction(k,plotfig)
moteur = tf(0.01,[0.005 0.06 0.1001]);
ref = 100;
filtre = 100;
C = pid(k(1), k(2), k(3), filtre);
%C = pid(4.6812, 0.85185, 0.15465);
BF = feedback(C*moteur,1);
t = linspace(0,5,5000);
[y temps] = step(BF*ref,t);

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
    if plotfig
        figure(3)
        plot(t,y)
    end

end
