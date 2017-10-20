%---------------------------------------------
% run_NDMs
% Simulate two nonsensense decision models (NDMs) and show that they can be
% used to provide precise fit to empirical RT distributions.
%
% Written by Doby Rahnev. Last update: 10/20/2017
%---------------------------------------------

clc
clear
close all

% Load data and decide on the number of trials per simulation
load dataToFit
factor = 100; %the factor by which the simulated trials exceed the number of trials in the dataset
N = 4177 * factor;

%% NDM1: cascade
% Set parameters
p_correct = .7438;
num_stages = 18;
stage_length = [32, 32]; %the upper bound of each stage length
nondecision_time = 180;

% Simulate the model
[choice, rt] = NDM1_cascade(p_correct, num_stages, stage_length, nondecision_time, N);

% Plot real data + fit
bin = 12;
subplot(2,2,1); 
hist(rt_real(correct_real==1),1:bin:1800); 
ylim([0, max(hist(rt_real(correct_real==1),1:bin:1800))+20]); 
xlim([0, max(rt_real)]); hold;
[n, x] = hist(rt(choice==2),1:bin:1800);
plot(x,n/factor, 'r', 'LineWidth', 3);
title('NDM 1: Cascade Model')
ylabel('RT count (correct trials)')

subplot(2,2,3); 
hist(rt_real(correct_real==0),1:bin:1800); 
ylim([0, max(hist(rt_real(correct_real==1),1:bin:1800))+20]); 
xlim([0, max(rt_real)]); hold;
[n, x] = hist(rt(choice==1),1:bin:1800);
plot(x,n/factor, 'r', 'LineWidth', 3);
xlabel('Time (ms)')
ylabel('RT count (error trials)')


%% NDM2: interruptions
% Set parameters
p_correct = .7438;
num_stages = 17;
p_interruption = [.97, .97]; %interruption probability for correct and error trials
nondecision_time = 190;

% Simulate the model
[choice, rt] = NDM2_interruptions(p_correct, num_stages, p_interruption, nondecision_time, N);

% Plot real data + fit
bin = 12;
subplot(2,2,2); 
hist(rt_real(correct_real==1),1:bin:1800); 
ylim([0, max(hist(rt_real(correct_real==1),1:bin:1800))+20]); 
xlim([0, max(rt_real)]); hold;
[n, x] = hist(rt(choice==2),1:bin:1800);
plot(x,n/factor, 'r', 'LineWidth', 3);
title('NDM 2: Interruptions Model')

subplot(2,2,4); 
hist(rt_real(correct_real==0),1:bin:1800); 
ylim([0, max(hist(rt_real(correct_real==1),1:bin:1800))+20]); 
xlim([0, max(rt_real)]); hold;
[n, x] = hist(rt(choice==1),1:bin:1800);
plot(x,n/factor, 'r', 'LineWidth', 3);
xlabel('Time (ms)')