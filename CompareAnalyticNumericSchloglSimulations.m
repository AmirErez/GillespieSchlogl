% Compare Analytic and numeric Schlogl 

% thetas = -0.1;
% hs = 0;
thetas = [-0.1:0.05:0.1];
hs = [-0.05:0.025:0.05];
nc = 300;

analytic_Pn = cell(length(thetas), length(hs));
simulation_Pn = cell(length(thetas), length(hs));

for tt=1:length(thetas)
    for hh=1:length(hs)
        Ising = struct;
        Ising.nc = nc;
        Ising.h = hs(hh);
        Ising.theta = thetas(tt);
        disp(['Theta=' num2str(Ising.theta) ' ; h=' num2str(Ising.h)]);

        Schlogl = SchloglFromIsing(Ising);        
        analytic_Pn{tt,hh} = AnalyticSchlogl1cell(Schlogl);
        
        [Pn,t,x] = SimulateSchlogl1cell_mex([10000,60000], nc, Schlogl, 0, 10000000);
        simulation_Pn{tt,hh} = Pn;
    end
end

disp('Done simulating');
%%

max_n = 0;
for tt=1:length(thetas)
    for hh=1:length(hs)
        temp = find(simulation_Pn{tt,hh} > eps,1, 'last');
        if(temp> max_n)
            max_n = temp;
        end
    end
end
if(max_n==0)
    max_n = 1;
end

figure();
for tt=1:length(thetas)
    for hh=1:length(hs)
        subplot(length(hs), length(thetas), tt + (hh-1)*length(thetas));        
        n = 1:length(simulation_Pn{tt,hh});
        plot(n, simulation_Pn{tt,hh}, '-b');
        hold on
        plot(n, analytic_Pn{tt,hh}, '--r');
        title(['$\theta=' num2str(thetas(tt)) ' ; h$=' num2str(hs(hh))], 'Interpreter', 'latex');
        xlim([0, max_n]);
    end
end