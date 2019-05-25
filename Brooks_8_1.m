% Title
% Kai brooks
% 24 May 2019
% Description
%
% Integrate the following two-dimensional integral: int(,0,1) *
% int(,0,sqrt(1-x^2)). Do this the not-so elegant way by writing your own
% trapezoidal rule (or Simpson's, or..). The answer is pi/4

clc
close all
clear all
format

% integrate
a = 1;  % iterations
lim = 10; % divisions for trap rule
adj = lim*18.28; % rounding adj

% init blank functions to integrate over
funcx = @(x) x;
funcy = @(y) y;

for n=1:lim
a(n) = integral(funcx,0,1/lim); % first eq
b(n) = integral(funcy,0,sqrt(1-(adj*a(n))^2));  % second eq
end

% sum individual trapezoids
ans = trapz(a)+trapz(b)

% Automated feedback script
test='Brooks_8_1.m';
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
url = ['mailto:',email];
web(url)