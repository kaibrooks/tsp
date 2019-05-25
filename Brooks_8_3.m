% Random I
% Kai brooks
% 24 May 2019
% Description
%
% Imagine 50 2D random walkers, all starting at the same bar, at the same
% time. Display them moving from the origin

clc
close all
clear all
format

rng('shuffle')  % randomize seed

steps = 1000; 
popSize = 50; % number of walkers, smaller pop for cpu power reasons

% far arr
path = cumsum(full(sparse(1:steps, randi(popSize,1,steps), [0 2*randi([0 1],1,steps-1)-1], steps, popSize))); 

hold on

for n = 1:popSize
   plot(1:steps, path(:,n)); % flip the vector elements
end

title('Last Call')
xlabel('Distance')
ylabel('BAC')

% Automated feedback script
test='Brooks_8_3.m';
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
url = ['mailto:',email];
web(url)