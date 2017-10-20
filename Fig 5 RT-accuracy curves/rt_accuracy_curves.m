%---------------------------------------------
% rt_accuracy_curves
% Generate hypothetical RT-accuracy curves based on a cumulative normal
% distribution for display purposes.
%
% Written by Doby Rahnev. Last update: 10/20/2017
%---------------------------------------------

clc
clear
close all

% Parameters of the 3 curves
mus     = [850, 600, 850];
sigmas  = [200, 150, 260];
heights = [1, .7, .8];

% X limit for plotting
x_limit = 0:1:2000;

% Plot the curves
figure
for i=1:length(mus)
    plot(x_limit, .5 + .25 * heights(i) * ...
        (1+erf( (x_limit-mus(i)) / (sigmas(i)*sqrt(2) ))), 'LineWidth', 6);
    hold on
end
ylabel('P(correct)');
xlabel('RT (ms)');