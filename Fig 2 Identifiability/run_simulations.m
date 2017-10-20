%---------------------------------------------
% run_simulations
% The code generates and plots the results of simulations of the drift 
% diffusion model (DDM) using two different sets of parameters.
%
% Written by Doby Rahnev. Last update: 10/20/2017
%---------------------------------------------

clc
clear
close all

% Decide whether to run a new simulation (use 1) or load the pre-computed one (use 0)
new_simulation = 0;

%% Set parameters
N = 1000000;
a   = [.1, .113];
v   = [.113, .2];
eta = [.1, .22];
z   = [.5, .4];
sz  = [0, .1];
Ter = [.25, .245];
st  = [.1, .11];


%% Simulate the model
if new_simulation
    [choice1, rt1] = simulate_ddm(a(1), v(1), eta(1), a(1)*z(1), a(1)*sz(1), Ter(1), st(1), N);
    [choice2, rt2] = simulate_ddm(a(2), v(2), eta(2), a(2)*z(2), a(2)*sz(2), Ter(2), st(2), N);
    save simulation_results a v eta z sz Ter st rt* choice*
else
    load simulation_results
end


%% Remove outlier RTs
cutoff = 2500; %in ms
rt1 = 1000*rt1(rt1 < cutoff/1000); choice1 = choice1(rt1 < cutoff);
rt2 = 1000*rt2(rt2 < cutoff/1000); choice2 = choice2(rt2 < cutoff);


%% Compute average accuracy and skewness of distribution
accuracy = [mean(choice1), mean(choice2)]
meanRT = [mean(rt1), mean(rt2)]
quantiles_correct = [quantile(rt1(choice1==1), [.1,.3,.5,.7,.9]); quantile(rt2(choice2==1), [.1,.3,.5,.7,.9])]
max_difference_correct = max(abs(diff(quantiles_correct)))
quantiles_incorrect = [quantile(rt1(choice1==0), [.1,.3,.5,.7,.9]); quantile(rt2(choice2==0), [.1,.3,.5,.7,.9])]
max_difference_incorrect = max(abs(diff(quantiles_incorrect)))
percent_outliers_removed = 100*[(N-length(rt1))/N, (N-length(rt2))/N]


%% Plot the RT distributions
rt1_correct = hist(rt1(choice1==1), 1:cutoff);
rt1_wrong = hist(rt1(choice1==0), 1:cutoff);
rt2_correct = hist(rt2(choice2==1), 1:cutoff);
rt2_wrong = hist(rt2(choice2==0), 1:cutoff);

figure
subplot(2,1,1);
plot(1:cutoff, rt1_correct, 'r', 'LineWidth', 2);
hold on
plot(1:cutoff, rt2_correct, 'b', 'LineWidth', 2);
xlim([0, 1400]);
ylim([0, 3000]);
title('RT for correct')
legend('DDM parameter set 1', 'DDM parameter set 2')

subplot(2,1,2); 
plot(1:cutoff, rt1_wrong, 'r', 'LineWidth', 2);
hold on
plot(1:cutoff, rt2_wrong, 'b', 'LineWidth', 2);
xlim([0, 1400]);
ylim([0, 3000]);
title('RT for error')
legend('DDM parameter set 1', 'DDM parameter set 2')
xlabel('Time (ms)')
ylabel('RT count')