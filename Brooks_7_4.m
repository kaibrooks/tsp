% Integration III
% Kai brooks
% 16 May 2019
% Description
%
% Numerically integrate the Fresnel integrals and plot

clc
close all
clear all
format

syms x
fplot(.5*( (0.5+fresnels(x)).^2+ (0.5+fresnelc(x)).^2), [-5 5])
grid on

% Automated feedback script
test='Brooks_7_4.m';
str = '&body= Hi Kai,? %0D%0A? %0D%0A??? Your program works well, except for: ';
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
url = ['mailto:',email];
web(url)