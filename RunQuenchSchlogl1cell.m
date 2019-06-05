function [t, mean_n] = RunQuenchSchlogl1cell(Ising_i, Ising_f, n_replicates, tspan, dt)
% Run several replicates of a quench from initial to final       
Schlogl_i = SchloglFromIsing(Ising_i);
Schlogl_f = SchloglFromIsing(Ising_f);


mean_n = NaN;
for rr=1:n_replicates
    if (mod(rr, 10)==0)
        disp(['Burnin replicate ' num2str(rr)]);
    end
    [t,n] = SimulateSchlogl1cell_Quench_mex(tspan, Ising_i.nc, Schlogl_i, Schlogl_f, dt);
    if(isnan(mean_n))
        mean_n = n;
    else
        mean_n = mean_n + n;
    end
end
mean_n = mean_n / n_replicates;

disp('Done simulating');
end