% Collects Gillespie output in folder and makes table with params and corr time

all_collect = {'quench_1cell'};

for aa=1:length(all_collect)
    collectdir = all_collect{aa};

    d = dir([collectdir filesep '*.mat']);
    
    tabInfo = table;
    
    for ff=1:length(d)
        disp(d(ff).name);
        loaded = load([collectdir filesep d(ff).name]);
        
        tempstruct = struct;
        tempstruct.theta_i = loaded.theta_i;
        tempstruct.theta_f = loaded.theta_f;
        tempstruct.h_i = loaded.h_i;
        tempstruct.h_f = loaded.h_f;
        tempstruct.nc = loaded.nc;
        tempstruct.n_replicates = loaded.n_replicates;
        tempstruct.t_start = loaded.tspan(1);
        tempstruct.t_end = loaded.tspan(2);
        tempstruct.dt = loaded.dt;
        tempstruct.tau_integral = loaded.tau_integral;
                
        tabInfo = [tabInfo; struct2table(tempstruct)];
    end
    writetable(tabInfo,[collectdir filesep 'collected.csv']);
end
