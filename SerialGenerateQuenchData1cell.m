% Runs quenches on the 1-cell Schlogl model

nc = 1000;
n_replicates = 500;
tspan = [1000,1200];
dt = 0.05;

theta_fs = [0 0.02 0.04 0.06 0.08 0.1];
theta_is = -0.1*ones(size(theta_fs));
h_is = 0*ones(size(theta_fs));
h_fs = 0*ones(size(theta_fs));

if(length(theta_is)~=length(theta_fs) || length(h_is)~=length(h_fs) || ...
   length(theta_is)~=length(h_is))
    error('All vectors needs to be the same length');
end

taus = zeros(length(theta_is),1);

for xx=1:length(theta_is)

    theta_i = theta_is(xx);
    theta_f = theta_fs(xx);
    h_i = h_is(xx);
    h_f = h_fs(xx);
    
    Ising_i = struct;
    Ising_i.nc = nc;
    Ising_i.h = h_i;
    Ising_i.theta = theta_i;
    
    Ising_f = struct;
    Ising_f.nc = nc;
    Ising_f.h = h_f;
    Ising_f.theta = theta_f;
    
    disp(['th_i=' num2str(Ising_i.theta) ' ; h_i=' num2str(Ising_i.h) ...
        ' ; th_f=' num2str(Ising_f.theta) ' ; h_f=' num2str(Ising_f.h)]);
    
    [t, mean_n] = RunQuenchSchlogl1cell(Ising_i, Ising_f, n_replicates, tspan, dt);
    dn = mean_n - mean_n(end);
    taus(xx) = sum(abs(dn)*dt)/abs(dn(1));
end