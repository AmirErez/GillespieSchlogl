function [t,x] = SimulateSchlogl1cell_Quench(tspan, x0, Schlogl_i, Schlogl_f, dt)
                                  
%#codegen
%   Usage:
%       [Pn,t, n] = SimulateSchlogl1cell( tspan, x0,Schlogl_i, Schlogl_f, MAX_OUTPUT_LENGTH,DISPLAY_EVERY )
%   Thermalize at Schlogl_i, then quench to Schlogl_f, and measure every dt
%   Returns:
%      Pn:              Binned data (to compare with single cell analytics)
%       t:              time vector          (Nreaction_events x 1)
%       x:              species amounts      (Nreaction_events x Nspecies)    
%
%   Required:
%       tspan:              Thermalization and final times, [t_init, t_final].
%
%       x0:                  Initial amount.
%
%       Schlogl:            Contains Schlogl model parameters
%                           .a, .s, .K
%       MAX_OUTPUT_LENGTH   If not 0, integer keeps track of individual events. 
%       DISPLAY_EVERY       Display time every how many events
%
%   Reference: 
%       Gillespie, D.T. (1977) Exact Stochastic Simulation of Coupled
%       Chemical Reactions. J Phys Chem, 81:25, 2340-2361.
%
%   Adapted by Amir Erez 2017 (amir.b.erez@gmail.com)
%      From code by Nezar Abdennur, 2012 <nabdennur@gmail.com>

%% Initialize
MAX_OUTPUT_LENGTH = ceil((tspan(2)-tspan(1))/dt);

t = zeros(MAX_OUTPUT_LENGTH, 1);
x = zeros(MAX_OUTPUT_LENGTH, 1);
curr_timepoint = 1; %Discrete timepoints
t(1) = 0;
x(1) = x0;

prevX = x0;
% newX = x0;
curT = 0;
rxn_count = 1;

% Initial: thermalize at
k_n1minus_i = 1;
k_n1plus_i = Schlogl_i.a*k_n1minus_i;
k_n2minus_i = k_n1minus_i/(Schlogl_i.K^2);
k_n2plus_i = k_n2minus_i*Schlogl_i.s;

% Final: Quench to
k_n1minus_f = 1;
k_n1plus_f = Schlogl_f.a*k_n1minus_f;
k_n2minus_f = k_n1minus_f/(Schlogl_f.K^2);
k_n2plus_f = k_n2minus_f*Schlogl_f.s;

stoich_matrix = [
1
-1
];

%% MAIN LOOP
while curT < tspan(2)        

    % Calculate reaction propensities   
    a_i = [
        k_n1plus_i + k_n2plus_i*prevX(1)*(prevX(1)-1)
        k_n1minus_i*prevX(1) + k_n2minus_i*prevX(1)*(prevX(1)-1)*(prevX(1)-2)     
        ];
    a_f = [
        k_n1plus_f + k_n2plus_f*prevX(1)*(prevX(1)-1)
        k_n1minus_f*prevX(1) + k_n2minus_f*prevX(1)*(prevX(1)-1)*(prevX(1)-2)
        ];

    if(curT< tspan(1))
        a = a_i;
    else
        a = a_f;
    end
    
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

    if(curr_timepoint > MAX_OUTPUT_LENGTH)       
        disp('Number of reaction events exceeded the number pre-allocated. Simulation terminated prematurely.');
        break;
    end
    
    % Update time and carry out reaction mu
    newX = prevX + stoich_matrix(mu); 
    curT = curT + tau;
    if((curT-tspan(1)) > curr_timepoint*dt)
%         fprintf('t = %.2f ; reaction %.0f\n',curT-tspan(1), rxn_count);
        t(curr_timepoint) = curT-tspan(1);
        x(curr_timepoint) = newX;
        curr_timepoint = curr_timepoint + 1;
    end

    rxn_count = rxn_count + 1;
    prevX = newX(1);    
end  

t = t(1:(end-1));
x = x(1:(end-1));
end

