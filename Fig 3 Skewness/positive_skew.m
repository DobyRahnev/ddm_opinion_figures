%---------------------------------------------
% positive_skew
% Use DDM to produce RT distributions with extreme positive skew by setting
% the boundary a very high. Note that nondecision time (Ter) plays little
% role in determining the skewness of the distribution. Unlike most DDM
% applications, for simplicity the time constant here is implicitly set at
% 1 and the times produced are in arbitrary units.
%
% Written by Doby Rahnev. Last update: 10/20/2017
%---------------------------------------------

clc
clear
close all

% Parameters
N = 100000;
v = .1;
c = .1;
eta = .2;
a = 5;
z = .5 * a;
sz = 0 * a;
Ter = 10.5;
st = 1;

% Simulate N trials
for trial=1:N
    
    % Initialize trial-specific variables
    time = 0;
    evidence = unifrnd(z-sz/2, z+sz/2); %determine starting point
    v_trial = normrnd(v, eta); %trial-specific drift rate
    nondectime_trial = unifrnd(Ter-st/2, Ter+st/2); %trial-specific nondecision time
    
    % Accumulate evidence until the accumulator reaches the bound
    while 1
        
        % Update time and evidence
        time = time + 1;
        evidence = evidence + normrnd(v_trial, c);

        % If bound is reached, determine RT
        if evidence >= a
            choice(trial) = 1;
            rt(trial) = time + nondectime_trial;
            break
        elseif evidence <= 0
            choice(trial) = 0;
            rt(trial) = time + nondectime_trial;
            break
        end
    end
end

% Compute average accuracy and skewness of distribution
accuracy = mean(choice)
skew_correct = skewness(rt(choice==1))
skew_error = skewness(rt(choice==0))

% Remove outlier RTs (larger than 120 units) for display purposes only!
% Computations are performed on the original RT distribution.
rt_trim = rt(rt < 120);
choice_trim = choice(rt < 120);

% Plot a histogram of the RTs and choices
figure
subplot(2,1,1); hist(rt_trim(choice_trim==1),1:120); ylim([0, max(hist(rt_trim(choice_trim==1),1:120))+20]); xlim([0, max(rt_trim)]);
title('RT for correct')
subplot(2,1,2); hist(rt_trim(choice_trim==0),1:120); ylim([0, max(hist(rt_trim(choice_trim==1),1:120))+20]); xlim([0, max(rt_trim)]);
title('RT for error')
xlabel('Time (a.u.)')
ylabel('RT count')