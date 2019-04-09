% Title
% Kai brooks
% 8 Apr 2019
% Description
%
%The equation of motion of a pendulum is given by:

% This equation has a well-known solution.  If we start the pendulum from 
% rest at an initial angle a_0 at an intial time t=0, then the solution is
% just a(t) = a_0 * cos(sqrt(g/l)*t). The period of the pendulum is given
% by T=2pi*sqrt(l/g)
% Write a script to evaluate the above equation for times t=0 to 10 in
% steps of 0.01, where a_0 = 0.01; g = 9.8; l = 4

% Although the calculation can be done using just a single line in MATLAB, 
% for this assignment you MUST use a for loop to evaluate the value of 
% a for each value in the t array.  HINT: The cosine function in MATLAB 
% is called cos and it takes radians as its argument.  The square root 
% function is called sqrt.  Use the plot function to plot the result.  Be 
% sure to label the axes of your plot.


clc
close all
clear all

format

a_0 = 0.01;
g = 9.8;
l = 4;
n = 0;

%a(t) = a_0 * cos(sqrt(g/l)*t); % solution
%T=2pi*sqrt(l/g) % period
 
for t=0:0.01:10
    n = n+1;    % Array index, since argument must be an integer
    a(n) = a_0 * cos(sqrt(g/l)*t);
end

figure(1)
plot(a)
xlim([0 n])
xlabel('\it t')
ylabel('\it a(t)')

% Automated feedback script
% test=scriptname.m;
% str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: '; 
% email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str ); 
% url = ['mailto:',email]; 
% web(url)