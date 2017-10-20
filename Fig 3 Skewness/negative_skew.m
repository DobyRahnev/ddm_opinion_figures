%---------------------------------------------
% negative_skew
% Use DDM to produce RT distributions with negative skew by employing
% collapsing boundaries. Note that nondecision time (Ter) plays little
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
a = 12;
z = .5 * a;
sz = 0 * a;
Ter = 10.5;
st = 1;
gamma = 20;

% Include collapsing bounds
bound_upper = a - (1 - exp(-([1:50]/gamma).^10)) * a/2;
bound_lower = (1 - exp(-([1:50]/gamma).^10)) * a/2;

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
        if evidence >= bound_upper(time)
            choice(trial) = 1;
            rt(trial) = time + nondectime_trial;
            break
        elseif evidence <= bound_lower(time)
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

% Plot a histogram of the RTs and choices
figure
subplot(2,1,1); hist(rt(choice==1),1:.5:50); ylim([0, max(hist(rt(choice==1),1:.5:50))+20]); xlim([0, max(rt) + 10]);
title('RT for correct')
subplot(2,1,2); hist(rt(choice==0),1:.5:50); ylim([0, max(hist(rt(choice==1),1:.5:50))+20]); xlim([0, max(rt) + 10]);
title('RT for error')
xlabel('Time (a.u.)')
ylabel('RT count')