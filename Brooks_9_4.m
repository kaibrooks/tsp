% Pendulum III
% Kai brooks
% 31 May 2019
% 
% solve a rocket equation

clc
close all
clear all
format

for i = 1:100
    fprintf('I trust nobody with my rocket equations, and my failure shall remain buried forever\n')
end

% Automated feedback script
test='Brooks_9_4.m';
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
url = ['mailto:',email];
web(url)