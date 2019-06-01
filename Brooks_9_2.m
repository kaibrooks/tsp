% ODE II
% Kai brooks
% 31 May 2019
% 
% solve diff(y,t) = y^2 + 1 using RK4

clc
close all
clear all
format

% Direct solve
syms a y(t)
fd = diff(y,t) == y^2 + 1
f = @(t,y) y^2 + 1;
dsolve(fd)

% RK4

h = 0.5; 
t_f = 5;
t = 0:h:t_f;                
y = zeros(1,numel(t)); % length of t
y(1) = 0; % y(0) but with a shifted indexing

for i = 2:numel(t)
    k1 = h * f(t(i-1), y(i-1)); % compute first 4 k's
    k2 = h * f(t(i-1)+ h/2, y(i-1) + k1/2);
    k3 = h * f(t(i-1)+ h/2, y(i-1) + k2/2);
    k4 = h * f(t(i-1) + h, y(i-1) + k3);
    y(i) = y(i-1) + (k1+ 2*k2 + 2*k3 +k4)/6;    % write y

end

fprintf('%.2f \t %.2f\n', t, y)

xlabel('t')
ylabel('y')
title('Real and Im parts')


% Automated feedback script
test='Brooks_9_2.m';
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
url = ['mailto:',email];
web(url)