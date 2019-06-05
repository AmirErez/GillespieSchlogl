function P_n = AnalyticSchlogl1cell(Schlogl)
% Analytic solution to Scholgl 1 cell model

% Ising.nc = 300;
% Ising.theta = 0;
% Ising.h = 0;
% N = Ising.nc*4;
% with order-one terms and index shift in birth propensity
% Schlogl.s = 3*(Ising.nc-1);
% Schlogl.K2 = 3*Ising.theta*Ising.nc^2 + 3*(Ising.nc-1)*(Ising.nc-2)+1;
% Schlogl.K = sqrt(Schlogl.K2);
% Schlogl.a = ((3*Ising.theta+3*Ising.h+1)*Ising.nc^3 - 6*(Ising.nc-1))/(Schlogl.K^2);

n = double(0:Schlogl.N)';
 
f = double(Schlogl.a*Schlogl.K2./((n-1).*(n-2)+Schlogl.K2)+Schlogl.s*(n-1).*(n-2)./((n-1).*(n-2)+Schlogl.K2));
c = [1; cumprod(f(2:end)./n(2:end))];
P_n = c/sum(c);