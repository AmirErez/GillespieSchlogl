% Collects Gillespie output in folder and makes table with params and corr time

%all_collect = {'quench_1cell'};
%all_collect = {'quench_NS'};
%all_collect = {'quench_all_h'};
%all_collect = {'quench_all_h_v2'};
%all_collect = {'only_one_dir'};
%all_collect = {'only_one_dir_v2'};
%all_collect = {'only_one_dir_nc3600'};
%all_collect = {'only_one_dir_nc3600_v2'};
all_collect = {'only_one_dir_nc10K'};

for aa=1:length(all_collect)
    collectdir = all_collect{aa};

    d = dir([collectdir filesep '*.mat']);
    
    tabInfo = table;
    
    for ff=1:length(d)
        disp(d(ff).name);
        try
           loaded = load([collectdir filesep d(ff).name]);
        
           tempstruct = struct;
           tempstruct.theta_i = loaded.Ising_i.theta;
           tempstruct.theta_f = loaded.Ising_f.theta;
           tempstruct.h_i = loaded.Ising_i.h;
           tempstruct.h_f = loaded.Ising_f.h;
           tempstruct.nc = loaded.Ising_i.nc;
           tempstruct.n_replicates = loaded.rr;
           tempstruct.t_start = loaded.tspan(1);
           tempstruct.t_end = loaded.tspan(2);
           tempstruct.dt = loaded.dt;
        catch
           warning(['Failed loading ' d(ff).name ]);
           continue
        end
        tempstruct.batchmean_tau = loaded.mean_tau;
        tempstruct.batchmean_std_tau = loaded.std_tau;

        corrtime=@(t,dx) (trapz(t,dx)/dx(1));

        tempstruct.mean_n0 = loaded.mean_n(1);
        tempstruct.mean_nf = loaded.mean_n(end);

        d_n = (loaded.mean_n - loaded.mean_n(end))/(loaded.mean_n(1)-loaded.mean_n(end));
	d_n(d_n<0.05) = 0;
        tempstruct.tau_n = corrtime(loaded.t, d_n);

        d_stdn = (loaded.std_n-loaded.std_n(end))/(loaded.std_n(1)-loaded.std_n(end));
        d_stdn(d_stdn<0.05)=0;
        tempstruct.tau_stdn = corrtime(loaded.t, d_stdn);
       
%        ft = fittype( 'a*exp(-x/tau)+C', 'independent', 'x', 'dependent', 'y' );
%        opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
%        opts.Display = 'Off';
%        opts.StartPoint = [0 10000 10];
%        opts.Lower = [-Inf 0 0.1];
%        opts.Upper = [Inf Inf 1000];
        % Fit model to data.
%        [fitresult, gof] = fit(loaded.t(loaded.mean_n>loaded.nc/10), loaded.mean_n(loaded.mean_n>loaded.nc), ft, opts);
%        tempstruct.tau_fit = fitresult.tau;
%%        ci = confint(fitresult);
%%        tempstruct.tau_fit100_err = ci(1,3)-fitresult.tau;

        tabInfo = [tabInfo; struct2table(tempstruct)];
    end
    writetable(tabInfo,[collectdir filesep 'collected.csv']);
end
