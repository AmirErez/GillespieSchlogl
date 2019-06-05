% Analytic solution to Scholgl 1 cell model

Ising.nc = 300;
Ising.theta = 0;
Ising.h = 0;
 

N = Ising.nc*4;
n = (0:N)';
 

% Depricated
% Schlogl.s = 3*Ising.nc;
% Schlogl.K = sqrt((Ising.theta+1)/3)*Schlogl.s;
% Schlogl.a = (3*(Ising.h+Ising.theta)+1)/(9*(Ising.theta+1))*Schlogl.s;
% f = Schlogl.a*Schlogl.K^2./((n-1).*(n-2)+Schlogl.K^2)+Schlogl.s*(n-1).*(n-2)./((n-1).*(n-2)+Schlogl.K^2);
% c = [1; cumprod(f(2:end)./n(2:end))];
% p1 = c/sum(c);
 
% with order-one terms and index shift in birth propensity
Schlogl.s = 3*(Ising.nc-1);
Schlogl.K2 = 3*Ising.theta*Ising.nc^2 + 3*(Ising.nc-1)*(Ising.nc-2)+1;
Schlogl.K = sqrt(Schlogl.K2);
Schlogl.a = ((3*Ising.theta+3*Ising.h+1)*Ising.nc^3 - 6*(Ising.nc-1))/(Schlogl.K^2);
f = Schlogl.a*Schlogl.K2./((n-1).*(n-2)+Schlogl.K2)+Schlogl.s*(n-1).*(n-2)./((n-1).*(n-2)+Schlogl.K2);
c = [1; cumprod(f(2:end)./n(2:end))];
p_n = c/sum(c);
 
 
figure(1); clf

plot(n,p_n,'b.-')
xlabel('n')
ylabel('$p_n$', 'Interpreter', 'latex')
title(['1 cell, \theta = ' num2str(Ising.theta) ', h = ' num2str(Ising.h)])
    
% legend({'mapping from dn/dt = k_1^+ - k_1^-n + k_2^+n^2 - k_2^-n^3',...
%     ['mapping from ' ...
%     'dn/dt = k_1^+ - k_1^-n + k_2^+(n-1)(n-2) - k_2^-n(n-1)(n-2)']},...
%     'location','ne')