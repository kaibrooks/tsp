% Plotting a Function
% Kai brooks
% 8 Apr 2019
% Plot a basic function from user input
%
% Write a MATLAB program to evaluate y = At^(3/2) + Bt + C, for values of
% constants A, B, and C that are input by the user. The "t" array for the
% calculation should be: t = [0 2 4 6 8 10] Your program should evaluate
% the equation in two ways.  MATLAB allows us to find the answer for all
% values in t in a single program statement.   Do that first to show that
% it is possible.  Then, evaluate the same equation for all t using a "for"
% loop which will go through each value in the t array, evaluate the
% expression, and store the result in a new array.  Plot the results.
% Label the axes.

clc
close all
clear all

t = [0 2 4 6 8 10];

fprintf('y = At^(3/2) + Bt + C \n');
a = input('Enter a value for A: ');
b = input('Enter a value for B: ');
c = input('Enter a value for C: ');

y1 = a*t.^(3/2) + b*t + c % Use .^ to multiply by each matrix element

figure(1)
subplot(2,1,1);
plot(y1,t);
title('Direct Calculation')
xlabel('\it t')
ylabel('\it y')

% Multiple each element individually and save in vector v
for n=1:6
    y2(n) = a*t(n)^(3/2) + b*t(n) + c;
end

y2

subplot(2,1,2);
plot(y1,t);
title('Loop Calculation')
xlabel('\it t')
ylabel('\it y')

% Automated feedback script
test=Brooks_1_2.m;
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: '; 
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str ); 
url = ['mailto:',email]; 
web(url)