function [Pn,t,x] = SimulateSchlogl1cell(tspan, x0,...
                                  Schlogl, MAX_OUTPUT_LENGTH,DISPLAY_EVERY)
%#codegen
%   Usage:
%       [Pn,t, n] = SimulateSchlogl1cell( tspan, x0,Schlogl, MAX_OUTPUT_LENGTH,DISPLAY_EVERY )
%
%   Returns:
%      Pn:              Binned data (to compare with single cell analytics)
%       t:              time vector          (Nreaction_events x 1)
%       x:              species amounts      (Nreaction_events x Nspecies)    
%
%   Required:
%       tspan:              Initial and final times, [t_init, t_final].
%
%       x0:                  Initial amount.
%
%       Schlogl:            Contains Schlogl model parameters
%                           .a, .s, .K
%       MAX_OUTPUT_LENGTH   Vector size to allocate (# of events)
%       DISPLAY_EVERY       Display time every how many events
%
%   Reference: 
%       Gillespie, D.T. (1977) Exact Stochastic Simulation of Coupled
%       Chemical Reactions. J Phys Chem, 81:25, 2340-2361.
%
%   Adapted by Amir Erez 2017 (amir.b.erez@gmail.com)
%      From code by Nezar Abdennur, 2012 <nabdennur@gmail.com>
%                   Dynamical Systems Biology Laboratory, University of Ottawa
%                   www.sysbiolab.uottawa.ca
%                   Created: 2012-01-19

%% Initialize
isFullTimeseries = true;

if(isFullTimeseries)
    T = zeros(MAX_OUTPUT_LENGTH, 1);
    X = zeros(MAX_OUTPUT_LENGTH, 1);
    T(1)     = tspan(1);
    X(1)   = x0;
else
   t = [];
   x = [];
end

prevX = x0;
% newX = x0;
curT = 0;
rxn_count = 1;

k_n1minus = 1;
k_n1plus = Schlogl.a*k_n1minus;
k_n2minus = k_n1minus/(Schlogl.K^2);
k_n2plus = k_n2minus*Schlogl.s;

Pn = zeros(x0(1)*10,1);

stoich_matrix = [
1 
-1
];

%% MAIN LOOP
while curT < tspan(2)        

    if(mod(rxn_count,DISPLAY_EVERY)==0)
        fprintf('t = %.2f\n',curT);
    end

    % Calculate reaction propensities   
    a = [
        k_n1plus + k_n2plus*prevX(1)*(prevX(1)-1)
        k_n1minus*prevX(1) + k_n2minus*prevX(1)*(prevX(1)-1)*(prevX(1)-2)     
        ];
    
    % Sample earliest time-to-fire (tau)
    a0 = sum(a);
    r = rand(1,2);
    tau = -log(r(1))/a0; %(1/a0)*log(1/r(1));
    
    % Sample identity of earliest reaction channel to fire (mu)
%     [~, mu] = histc(r(2)*a0, [0;cumsum(a(:))]); 
    
    % ...alternatively...
    mu = find((cumsum(a) >= r(2)*a0), 1,'first');

    % ...or...
    %mu=1; s=a(1); r0=r(2)*a0;
    %while s < r0
    %   mu = mu + 1;
    %   s = s + a(mu);
    %end

    if (isFullTimeseries && (rxn_count + 1 > MAX_OUTPUT_LENGTH))        
        disp('Number of reaction events exceeded the number pre-allocated. Simulation terminated prematurely.');
        break;
    end
    
    % Update time and carry out reaction mu
    newX = prevX + stoich_matrix(mu); 
    curT = curT + tau;
    if(isFullTimeseries)
        T(rxn_count+1)   = curT;
        X(rxn_count+1) = newX;
    end

    Pn(prevX(1)) = Pn(prevX(1))+tau;
    rxn_count = rxn_count + 1;
    prevX = newX(1);
    
end  


Pn = Pn/sum(Pn);

% Return simulation time course
if (isFullTimeseries)
    t = T(1:rxn_count);
    x = X(1:rxn_count);
    if t(end) > tspan(2)
        t(end) = tspan(2);
        x(end) = X(rxn_count-1);
    end
end

end

