% Integration II aka Pendulum II
% Kai brooks
% 16 May 2019
%
% Finds the period of a large amplitude pendulum as function
% of the amplitude and plot it.

clc
close all
clear all
format

step = 1E-4;
theta = 0:step:pi/2;
pendulum = zeros(length(theta),2); % preallocate memory

for k = 1:length(theta);
    f2=@(x) 1./sqrt(1.-(sin(theta(k)).*sin(x)));
    pendulum(k,1) = integral(@(x)f2(x),0,pi/2);
    pendulum(k,2) = theta(k);
end

Period = 4*pendulum(:,1);

figure('units','normalized','outerposition',[0 0 1 1]);
plot(pendulum(:,2),Period);
xlabel('Amplitude, \theta');
ylabel('Period T (seconds)');
grid on;


% Automated feedback script
test='Brooks_7_3.m';
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
url = ['mailto:',email];
web(url)