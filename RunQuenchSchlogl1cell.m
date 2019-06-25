function RunQuenchSchlogl1cell(Ising_i, Ising_f, n_replicates, tspan, dt, outfile)
% Run several replicates of a quench from initial to final       
Schlogl_i = SchloglFromIsingOldMapping(Ising_i);
Schlogl_f = SchloglFromIsingOldMapping(Ising_f);

sum_n = 0;
sum_nsqr = 0;

sum_tau = 0;
sum_tau_sqr = 0;

for rr=1:n_replicates
    if (mod(rr, 10)==0)
        disp(['Done replicate ' num2str(rr)]);
    end
    [t, n] = SimulateSchlogl1cell_Quench_mex(tspan, Ising_i.nc, Schlogl_i, Schlogl_f, dt);

    % Make sure to interpolate since Gillespie doesn't produce precise timepoints,
    % making averaging difficult. (Though these should self average).
    t_interp = (dt:dt:(tspan(2)-tspan(1)))';
    n_interp = interp1(t,n,t_interp);
    if(any(isnan(n_interp)))
       f = find(isnan(n_interp));
       if(length(f)>1)
          disp(['Warning: ' num2str(sum(isnan(n_interp))) ' nans in n_interp']);
       end
       n_interp(f) = n(f);
    end

    sum_n = sum_n+n_interp;
    mean_n = sum_n/rr;
    sum_nsqr = sum_nsqr+(n_interp.^2);
    std_n = sqrt(sum_nsqr/rr - mean_n.^2);

    dn = (n-n(end))/(n(1)-n(end));
    temp_tau = trapz(t,dn);
    sum_tau = sum_tau + temp_tau;
    mean_tau = sum_tau/rr;
    sum_tau_sqr = sum_tau_sqr + temp_tau^2;
    std_tau = sqrt(sum_tau_sqr/rr - mean_tau^2);

    t = t_interp;

    if (mod(rr, 50)==0)
        clear('temp_tau');
        clear('n');
        clear('dn');
        disp(['Saving replicate ' num2str(rr)]);
        save(outfile);
    end    
end

disp('Done simulating');
end
