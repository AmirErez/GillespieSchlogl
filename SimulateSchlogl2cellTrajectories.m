function [nSteps,T,X,tau_n, tau_m, batchMeans] = SimulateSchlogl2cellTrajectories(tspan, x0,...
                                  Schlogl, MAX_OUTPUT_LENGTH,DISPLAY_EVERY)
%#codegen
%DIRECTMETHOD Implementation of the Direct Method variant of the Gillespie algorithm
%   Returns:
%       t:              time vector          (Nreaction_events x 1)
%       x:              species amounts      (Nreaction_events x Nspecies)    
%
%   Required:
%       tspan:          Initial and final times, [t_init, t_final].
%
%       x0:             Initial species amounts, [S1_0, S2_0, ... ].
%
%       stoich_matrix:  Matrix of stoichiometries (Nreactions x Nspecies).
%                       Each row gives the stoichiometry of a reaction.
%
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
%num_rxns = size(stoich_matrix, 1);
isFullTimeseries = true;
if(isFullTimeseries)
    T = zeros(MAX_OUTPUT_LENGTH, 1);
    X = zeros(MAX_OUTPUT_LENGTH, 2);
    T(1)     = tspan(1);
    X(1,:)   = x0;
else
   T = [];
   X = [];
end

prevX = x0;
newX = NaN*prevX;
curT = 0;
rxn_count = 1;

% For correlation time using method of batch means
%nBatches = floor(tspan(2)^(1/3));
%batchTime = tspan(2)/nBatches;
batchTime = 1000;
nBatches = floor(tspan(2)/batchTime);

batchMeans = zeros(nBatches,2);
batchVals = NaN(MAX_OUTPUT_LENGTH,2);
totalVariance = zeros(1,2);

% DISPLAY_EVERY = 100000;

k_n1minus = 1;
k_m1minus = k_n1minus;
k_n1plus = Schlogl.a*k_n1minus;
k_m1plus = Schlogl.a*k_m1minus;
k_n2minus = k_n1minus/(Schlogl.K^2);
k_m2minus = k_m1minus/(Schlogl.K^2);
k_n2plus = k_n2minus*Schlogl.s;
k_m2plus = k_m2minus*Schlogl.s;
gamma = Schlogl.g/k_n1minus/3*((Schlogl.s+3)/Schlogl.K)^2;

% Pn = zeros(x0(1)*10,1);
% Pm = zeros(x0(1)*10,1);
% Pnm = zeros(x0(1)*6,x0(1)*6);
% Pz = zeros(x0(1)*20,1);
% Pw = zeros(x0(1)*10,1);

stoich_matrix = [
1 0
-1 0
-1 1
1 -1
0 1
0 -1
];

%% MAIN LOOP
batchCounter = 0;
counterInBatch = 1;
is_burnin = true;
while curT < tspan(2)        

    if(curT > batchCounter*batchTime)
        if(batchCounter>0) % Statistics for previous batch
            batchMeans(batchCounter,:) = nanmean(batchVals(1:counterInBatch,1));
            totalVariance = (totalVariance*batchCounter + nanmean(batchVals(1:counterInBatch,1).^2) - batchMeans(batchCounter,:).^2)/(batchCounter+1);
        end        
        batchCounter = batchCounter+1;
        counterInBatch = 1;
%         batchVals = NaN(1E7,2);
    end
    
    
    
    if(mod(rxn_count,DISPLAY_EVERY)==0)
         if(is_burnin==true)
            is_burnin = false;
            fprintf('Finished burnin\n');
            curT = 0;
            rxn_count = 1;
         else 
            fprintf('t = %.2f\n',curT);
         end
    end

    % Calculate reaction propensities   
    a = [
        k_n1plus + k_n2plus*prevX(1)*(prevX(1)-1)
        k_n1minus*prevX(1) + k_n2minus*prevX(1)*(prevX(1)-1)*(prevX(1)-2)
        gamma*prevX(1)
        gamma*prevX(2)
        k_m1plus + k_m2plus*prevX(2)*(prevX(2)-1)
        k_m1minus*prevX(2) + k_m2minus*prevX(2)*(prevX(2)-1)*(prevX(2)-2)
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
        if(isFullTimeseries)
            T = T(1:rxn_count);
            X = X(1:rxn_count,:);
        end
        disp('Number of reaction events exceeded the number pre-allocated. Simulation terminated prematurely.');
        break;
    end
    
    % Update time and carry out reaction mu
    newX = prevX + stoich_matrix(mu,:); 
    curT = curT + tau;
    if(isFullTimeseries)
        T(rxn_count+1)   = curT;
        X(rxn_count+1,:) = newX;
    end

    batchVals(counterInBatch,:) = newX;
    counterInBatch = counterInBatch+1;
    
%     Pn(prevX(1)+1) = Pn(prevX(1)+1)+tau;
%     Pm(prevX(2)+1) = Pn(prevX(2)+1)+tau;
%     Pnm(prevX(1)+1,prevX(2)+1) = Pnm(prevX(1)+1,prevX(2)+1)+tau;    
%     Pz(sum(prevX)+1) = Pz(sum(prevX)+1) + tau;
%     w = abs(diff(prevX))+1;
%     Pw(w) = Pw(w) + tau;
     
    rxn_count = rxn_count + 1;
    prevX = newX;
    
end  

% Pn = Pn/sum(Pn);
% Pm = Pm/sum(Pm);
% Pnm = Pnm/sum(Pnm(:));
% Pz = Pz / sum(Pz);
% Pw = Pw / sum(Pw);
nSteps = rxn_count;

% Batch means:
batchMeans(batchCounter,:) = nanmean(batchVals,1);
totalVariance = (totalVariance*batchCounter + nanmean(batchVals.^2,1) - batchMeans(batchCounter,:).^2)/(batchCounter+1);
varBatches = mean(batchMeans.^2,1) - mean(batchMeans,1).^2;
tau_n = batchTime * varBatches(1)/2/totalVariance(1);
tau_m = batchTime * varBatches(2)/2/totalVariance(2);

% Return simulation time course
T = T(1:rxn_count);
X = X(1:rxn_count,:);
if T(end) > tspan(2)
    T(end) = tspan(2);
    X(end,:) = X(rxn_count-1,:);
end    

end

