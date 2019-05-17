% Integration III
% Kai brooks
% 16 May 2019
% Description
%
% 

clc
close all
clear all
format

syms x
fplot(fresnels(x),[-5 5])
grid on

% Automated feedback script
% test='Brooks_7_4.m';
% str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
% email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
% url = ['mailto:',email];
% web(url)