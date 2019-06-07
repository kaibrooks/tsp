% Title
% Kai brooks
% 8 May 2019
% Description
%

clc
close all
clear all
format

% Plot normal dist, mu = 0, sigma = 1
% P = [ 1/(sqrt(2*pi)) ] * e^[ (-x^2) / 2 ]
% Integrate P dx from 1 to 9
% 1/3 * e^-40 = 10^-18 = 2^-60 (40 powers of 2 ~ 10^-12 since e = ~2.7)
%

p =@(x) [ 1/(sqrt(2*pi)) ] * exp( (-x.^2) / 2 )

hold on
for x = 0:10
 y = p(x);
 plot(x,p(x),'kx')
end

integral(p ,1,9)