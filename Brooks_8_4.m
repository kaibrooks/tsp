% Random II
% Kai brooks
% 24 May 2019
% Description
%
% Generate a series of random numbers, starting from a uniform distribution
% using a psuedorandom number generator between 0 and 1 that creates a
% distribution that looks as shown in the figure

clc
close all
clear all
format

rng('shuffle') % seed rng

max = 20000

for n = 1:max
    a = rand();  % generate a base number
    w = a^2;    % add a weight vector
    x(n) = w;
end

figure(1)
plot(x,'.')
title('Weighted granular noise')

for n = 1:max
    b = rand();  % generate a base number
    
    y(n) = b;
end

figure(2)
histogram(y,50)
title('Random non-weighted distribution')


% Automated feedback script
test='Brooks_8_4.m';
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
url = ['mailto:',email];
web(url)