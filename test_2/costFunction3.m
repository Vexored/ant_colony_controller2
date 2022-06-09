function cost_value=costFunction3(k)

moteur = tf(1.822,[8.569 1]);
ref = 100;
filtre = 100;
C = pid(k(1), k(2), k(3), filtre);
%C = pid(0.1049, 0.5, 0.1);
BF = feedback(C*moteur,1);
t = linspace(0,100,100000);
[y, temps] = step(BF*ref,t);

err=ref-y;
[n,~]=size(err);
cost_value=0;
for i=1:n
    % cost_value=cost_value+(err(i))^2 ;  % ISE
    % cost_value=cost_value+abs(err(i));  % IAE
    cost_value=cost_value+temps(i)*abs(err(i));  % ITAE
    %cost_value=cost_value+temps(i)*(err(i))^2;  % MSE
end

end
