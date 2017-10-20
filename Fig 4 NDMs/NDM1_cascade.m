function [choice, rt] = NDM1_cascade(p_correct, num_stages, stage_length, nondeciontime, N)

% Simulate N trials
for trial=1:N
    
    % Initialize trial-specific variables
    choice(trial) = 1 + (rand < p_correct); %1: error, 2: correct

    % Start cascading through the stages
    for stage=1:num_stages
        timeTakenPerStage(stage) = stage_length(choice(trial)) * log(1/rand);
    end
    rt(trial) = sum(timeTakenPerStage) + nondeciontime; 
end