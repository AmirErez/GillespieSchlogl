function RunQuenchSchlogl1cell(Ising_i, Ising_f, n_replicates, tspan, dt, outfile)
% Run several replicates of a quench from initial to final       
Schlogl_i = SchloglFromIsingOldMapping(Ising_i);
Schlogl_f = SchloglFromIsingOldMapping(Ising_f);

mean_n = NaN;
mean_nsqr = NaN;
for rr=1:n_replicates
    if (mod(rr, 10)==0)
        disp(['Done replicate ' num2str(rr)]);
    end
    [t, n] = SimulateSchlogl1cell_Quench_mex(tspan, Ising_i.nc, Schlogl_i, Schlogl_f, dt);
    if(rr==1)
        mean_n = n;
        mean_nsqr = n.^2;
    else
        mean_n = (mean_n*(rr-1) + n)/rr;
        mean_nsqr = (mean_nsqr*(rr-1) + n.^2)/rr;
        std_n = sqrt(mean_nsqr - mean_n.^2);
    end
    dn = mean_n - mean(mean_n(end-10:end));
    tau_integral = sum(abs(dn)*dt)/abs(dn(1));
    if (mod(rr, 50)==0)
        disp(['Saving replicate ' num2str(rr)]);
        save(outfile);
    end    
end

disp('Done simulating');
end