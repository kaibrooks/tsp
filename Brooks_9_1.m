% ODE I
% Kai brooks
% 31 May 2019
%
% solve diff(y,t) = y^2 + 1

clc
close all
clear all
format

syms y(t)
eqn = diff(y,t) == y^2 + 1
a = dsolve(eqn, y(0) == 0)

t = [0 20];

hold on
ezplot(real(a))
ezplot(imag(a))
xlabel('t')
ylabel('y')
title('Real and Im parts')



% Automated feedback script
test='Brooks_9_1.m';
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
url = ['mailto:',email];
web(url)