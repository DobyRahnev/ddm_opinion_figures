function [choice, rt] = NDM2_interruptions(p_correct, num_stages, p_interruption, nondecision_time, N)

% Simulate N trials
for trial=1:N
    
    % Initialize trial-specific variables
    choice(trial) = 1 + (rand < p_correct); %1: error, 2: correct
    time = 1;
    
    % Proceed through the stages of decision making; each stage is
    % immediately completed unless interrupted (with P = p_interruption)
    for stage=1:num_stages
        while 1
            time = time + 1;
            if rand > p_interruption(choice(trial))
                break;
            end
        end
    end
    rt(trial) = time + nondecision_time; 
end