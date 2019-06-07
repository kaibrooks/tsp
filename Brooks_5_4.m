% Roots III
% Kai brooks
% 2 May 2019
% Description
%
% Find the two lowest solutions to the square well problem. Let's pick
% a = 0.7nm, m = m_electron, and V_0 = 17eV. Plot the potential and the
% wave functions for these solutions. Pick one unknown values, for instance
% D, to be equal to 1. There is no need to normalize the wave function.

clc
close all
clear all
format

v_0 = 17;   % initial voltage
m = 1.0;    % in em
a = 0.7;    % in nm
hbar2 = 0.076199682; % hbar^2 in eV
E = 0:0.0001:v_0;

y1 = tan(a * sqrt(2 * m * E / hbar2)) ; % even function
y2 = sqrt( (v_0-E)./E ); % \mu / k
y3 = 1:v_0 % plotting vector

plot(E,y1,'b.', 'MarkerSize',1);
xlabel('E (eV)'); ylabel('Tan, Cot, and Sqrt[(v_0-E)/E]');
hold on;

plot(E,y3,'g.', 'MarkerSize',1 );
plot(E,y2,'r');

axis([0 v_0 -05 17]);

caption = sprintf('V_0 = %d eV', v_0);
title(caption, 'FontSize', 20);
grid on
legend

% Automated feedback script
test='Brooks_5_4.m';
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
url = ['mailto:',email];
web(url)