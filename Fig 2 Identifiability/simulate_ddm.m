function [choice, rt] = simulate_ddm(a, v, eta, z, sz, Ter, st, N)

%---------------------------------------------
% simulate_ddm
% The code simulates a complete DDM using its 7 parameters (see below).
% Simulations are performed for N number of trials.
%
% Written by Doby Rahnev. Last update: 10/20/2017
%---------------------------------------------

%% Define the parameters
% Simulation parameters
if ~exist('N','var') || isempty(N) %number of trials (iterations of the simulation)
    N = 2000;
end
trialsInSeries = 2500; %this parameter is optimized for speed, it doesn't affect the model

% Standard DDM parameters: usually kept constant
tau = 0.001; %time step for each new data point
c = 0.1; %variability of the drift rate within a trial

% DDM parameters
% Boundary
if ~exist('a','var') || isempty(a) %upper threshold; lower threshold = 0
    a = 0.16;
end

% Drift
if ~exist('v','var') || isempty(v) %drift rate
    v = 0.05;
end
if ~exist('eta','var') || isempty(eta) %variability of the drift rate across trials
    eta = 0.1;
end

% Starting point
if ~exist('z','var') || isempty(z) %starting point
    z = a/2;
end
if ~exist('sz','var') || isempty(sz) %range of the starting point (uniform)
    sz = 0;
end

% Nondecision time
if ~exist('Ter','var') || isempty(Ter) %nondecision time
    Ter = .26;
end
if ~exist('st','var') || isempty(st) %variability in the non decision time
    st = 0;
end

%% Loop over trials
for trial=1:N
    
    % Trial-specific quantities
    startPoint = unifrnd(z-sz/2, z+sz/2); %starting point for this trial
    v_trial = normrnd(v, eta); %the drift rate for this trial
    
    % Start the diffusion process within a trial
    nTimeseriesSimulated = 0;
    while 1
        
        % Generate trialsInSeries points in the accumulation process
        timeseries = cumsum([startPoint, normrnd(v_trial*tau, c*sqrt(tau), 1, trialsInSeries)]);
        nTimeseriesSimulated = nTimeseriesSimulated + 1;
        
        % Check if either boundary was crossed
        firstCrossUpper = sum([0, find(timeseries >= a, 1)]);
        firstCrossLower = sum([0, find(timeseries <= 0, 1)]);
        
        % If no boundary was crossed, generate another timeseries; if a
        % boundary was crossed, save choice and RT
        if firstCrossUpper + firstCrossLower == 0 %no boundary crossing
            startPoint = timeseries(end);
        else %a boundary was crossed
            if firstCrossUpper == 0 %lower boundary was crossed
                crossTime = firstCrossLower + (nTimeseriesSimulated-1) * trialsInSeries;
                choice(trial) = 0;
            elseif firstCrossLower == 0 %upper boundary was crossed
                crossTime = firstCrossUpper + (nTimeseriesSimulated-1) * trialsInSeries;
                choice(trial) = 1;
            else %both boundaries were crossed, choose the first crossing
                choice(trial) = firstCrossUpper < firstCrossLower;
                crossTime = min([firstCrossLower,firstCrossUpper]) + (nTimeseriesSimulated-1) * trialsInSeries;
            end
            rt(trial) = (crossTime-1) * tau + unifrnd(Ter-st/2, Ter+st/2);
            break;
        end
    end
end