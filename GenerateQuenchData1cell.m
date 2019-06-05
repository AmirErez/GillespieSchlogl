function GenerateQuenchData1cell(theta_i, theta_f, h_i, h_f, outfile)
% Runs quenches on the 1-cell Schlogl model

nc = 1000;
n_replicates = 500;
tspan = [1000,1200];
dt = 0.05;

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

RunQuenchSchlogl1cell(Ising_i, Ising_f, n_replicates, tspan, dt, outfile);
