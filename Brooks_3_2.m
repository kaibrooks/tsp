% Beer Foam
% Kai brooks
% 16 Apr 2019
% Description
%
% Read the paper: A. Leike, ?Demonstration of the exponential decay law 
% using beer froth,? Eur. J. Phys. 23 (2002) 21-26. It is on D2L ? 
% beerdecay.pdf. Use the data provided in the file erdinger_weiss.txt (read
% the data into your program):
% to do a least squares weighted fit to the following function:
% height(t)=height(0) * exp( - time/ {half-life of beer foam} )
% or using h_i for the height at time t_i and /tau for the half-life of 
% beer foam: h_i = h_0 * e^(-t/tau)
% This function cannot be dealt with using ?no-brains? application of the 
% equations (see also chapter 6 of Bevington, also on D2L). It is not a 
% simple straight line. One needs to linearize this by taking the logarithm
% on both sides. Hence, you will have to do error propagation. The error in
% ln(h_i) is not simply /sigma_i. You can read Assignment 3 for Wednesday 
% of week 3 PH 322 ? ver 1.00 ? 2019.docx ? 45
% http://mathworld.wolfram.com/ErrorPropagation.html for more information 
% (in particular, you might commit to memory equation 7 ? the ?error 
% propagation equation? ? of the aforementioned website). Write your own 
% program. You can compare it with the MATLAB produced answer using the 
% appropriately modified posted script: wlsqr.m. Note that inverse variance
% (which is what MATLAB needs in lscov, i.e., the individual weights) is 
% (standard deviation)^-2 or (\sigma_i)^-2

clc
close all
clear all
format

% import data from file

s = load('data/erdinger_weiss.txt');
t = s(:,1); % time
h = s(:,2); % height
d = s(:,3); % stdev

s;

% write to a single array
[n,m] = size(s);    % get the length of the array as n
% for i=1:n
%     a(1,i) = t(i);
%     a(2,i) = h(i);
%     a(3,i) = d(i);
% end

x=[1:t(n)]; % create vector from 1:(end time in data file)

p = polyfit(t,h,1);
y = polyval(p,x);

[p, stp] = lscov(t,h,d);

hold on
figure(1)

plot(t,h,'o')
plot(x,y)
plot(x,polyval(p,x))


xlabel('\it t')
ylabel('\it h')

legend('data','least squares fit', 'lse')

%plot(p,t);

% height(t)=height(0) * exp(- time/{half-life of beer foam} )





% Automated feedback script
% test='filename.m';
% str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
% email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
% url = ['mailto:',email];
% web(url)