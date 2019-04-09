% Title
% Kai brooks
% 8 Apr 2019
% Description
%
% The Fibonacci sequence is named after an Italian mathematician: Leonardo
% Bonacci (c. 1170 - c. 1250) known as Fibonacci, and also Leonardo of
% Pisa, Leonardo Pisano Bigollo, and as Leonardo Fibonacci.  His 1202 book
% Liber Abaci introduced the sequence to Western European mathematics,
% although the sequence had been described earlier in Indian mathematics.
% In mathematical terms, the sequence F_n of Fibonacci numbers is defined by
% the recurrence relation F_n = F_n-1 + F_n-2 with seed values F_1 = 1, F_2
% = 1.
% The Fibonacci sequence is represented by the numbers in the following
% integer sequence: 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, or
% (often, in modern usage): 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144 
% By definition, the first two numbers in the Fibonacci sequence are
% either 1 and 1, or 0 and 1, depending on the chosen starting point of the
% sequence, and each subsequent number is the sum of the previous two.
% Write a MATLAB script which computes the Fibonacci sequence and plots the
% ratio of successive members of the series (e.g. plot 1/1 = 1; 2/1 = 2;
% 3/2 = 1.5; 5/3 = 1.67; etc.).  Show that this converges to a single
% value, the "golden ratio" of 1.61803398875 (etc.).  How many iterations
% does it take before successive iterations do not change by more than
% 0.000,001 or 10-6 or 1E-6?

clc
close all
clear all

format long

maxLoops = 100;        % Set a safety breakpoint
f(1) = 1;
f(2) = 1;
goldenRatio = 1.61803398875; % Golden ratio
loopCount = 0;


for n=3:maxLoops
    loopCount = loopCount+1;
    
    f(n)=f(n-2)+f(n-1);         % compute golden ratio values to an array
    ratio(n-2) = f(n)/f(n-1);   % put the first ratio in the starting index
    
    error =  ratio(n-2) / goldenRatio;  % error ratio of known and calculated
    
    if error > 0 && error < 1   % set bounds to prevent breaking too early
        if 1-error < 0.000001   % break when lower than desired error
            break;
        end
    end
    
end

fprintf('Break after %d loops\n', loopCount);
fprintf('Calculated ratio: %f11 \n', ratio(loopCount)) 
fprintf('Error: %f6 \n',1-error)

% Automated feedback script
% test=scriptname.m;
% str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
% email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
% url = ['mailto:',email];
% web(url)