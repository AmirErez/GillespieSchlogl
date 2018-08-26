% Collects Gillespie output in folder and makes table with Shannon and Renyi entropies

all_collect = {'ProductionManyThetasParticularNcs','ProductionTheta0Scaling'};

for aa=1:length(all_collect)
    collectdir = all_collect{aa};

    d = dir([collectdir filesep '*.mat']);
    
    tabInfo = table;
    
    for ff=1:length(d)
        disp(d(ff).name);
        load([collectdir filesep d(ff).name]);
        
        tempstruct = struct;
        tempstruct.g = GillespieOut.Ising.g;
        
        if(abs(tempstruct.g-sqrt(10))<4e-4), tempstruct.g = sqrt(10); end
        
        tempstruct.theta = GillespieOut.Ising.theta;
        tempstruct.h = GillespieOut.Ising.h;
        tempstruct.nc = GillespieOut.Ising.nc;
        tempstruct.tmax = GillespieOut.Ising.tspan(2);
        
        if(isfield(GillespieOut,'tau_n'))
            tempstruct.tau_n = GillespieOut.tau_n;
            tempstruct.tau_m = GillespieOut.tau_m;
        end
        
        % Shannon:
        f = find(GillespieOut.Pn);
        tempstruct.Sn = -sum(GillespieOut.Pn(f).*log(GillespieOut.Pn(f)));
        f = find(GillespieOut.Pm);
        tempstruct.Sm = -sum(GillespieOut.Pm(f).*log(GillespieOut.Pm(f)));
        nz = nonzeros(GillespieOut.Pnm);
        tempstruct.Snm = -sum(nz.*log(nz));
        tempstruct.IShannon = tempstruct.Sn+tempstruct.Sm-tempstruct.Snm;
        
        % Renyi2
        tempstruct.Rn = -log(sum(GillespieOut.Pn.^2));
        tempstruct.Rm = -log(sum(GillespieOut.Pm.^2));
        tempstruct.Rnm = -log(sum(nz.^2));
        tempstruct.IRenyi2 = tempstruct.Rn + tempstruct.Rm - tempstruct.Rnm;
        
        % Renyi3
        tempstruct.Rn3 = (1/(1-3))*log(sum(GillespieOut.Pn.^3));
        tempstruct.Rm3 = (1/(1-3))*log(sum(GillespieOut.Pm.^3));
        tempstruct.Rnm3 = (1/(1-3))*log(sum(nz.^3));
        tempstruct.IRenyi3 = tempstruct.Rn3 + tempstruct.Rm3 - tempstruct.Rnm3;
        
        % Renyi4
        tempstruct.Rn4 = (1/(1-4))*log(sum(GillespieOut.Pn.^4));
        tempstruct.Rm4 = (1/(1-4))*log(sum(GillespieOut.Pm.^4));
        tempstruct.Rnm4 = (1/(1-4))*log(sum(nz.^4));
        tempstruct.IRenyi4 = tempstruct.Rn4 + tempstruct.Rm4 - tempstruct.Rnm4;
        
        tabInfo = [tabInfo; struct2table(tempstruct)];
    end
    writetable(tabInfo,[collectdir '.csv']);
end
