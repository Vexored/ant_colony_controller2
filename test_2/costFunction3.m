function cost_value=costFunction3(k)

moteur = tf(1.822,[8.569 1]);
ref = 100;
filtre = 100;
%k(:,1) = data.simulation.as(10).pid(:,1),
%k(:,2) = data.simulation.as(10).pid(:,2),
%k(:,3) = data.simulation.as(10).pid(:,3),

C = pid(k(1), k(2), k(3), filtre);

%C = pid(5, 10, 0.8, filtre);
BF = feedback(C*moteur,1);
t = linspace(0,20,100000);
[y, temps] = step(BF*ref,t);

err=ref-y;
[n,~]=size(err);
cost_value=0;
 for i=1:n
%     cost_value=cost_value+(err(i))^2 ;  % ISE
%     % cost_value=cost_value+abs(err(i));  % IAE
     cost_value=cost_value+exp(temps(i))*abs(err(i));  % ITAE
%     %cost_value=cost_value+temps(i)*(err(i))^2;  % MSE
%     cost_value=trapz(temps(y>ref), y(y>ref));
 end
[y_max(1), y_max(2)] = max(y);
if(y_max(1) > ref)
    cost_value = cost_value + (cost_value*(y_max(1)/ref))^2;
end
%cost_value = cost_value + (cost_value*(y_max(1)/ref))/2;
%cost_value=cost_value + trapz(temps(y>ref), y(y>ref))^2;
end
