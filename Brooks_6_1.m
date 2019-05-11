% Title
% Kai brooks
% 8 Apr 2019
% Description
% 
% Plot the Airy pattern, i.e I/I_0. Use the built-in Bessel function
% J_1(rho), besselj(1, rho). Next approximate the same 0 plot, using MATLAB's 
% function for J_1(rho) but only those values of J_1(rho) at 
% rho = 0,1,2,..10

% Airy function:
% I_0 * [  ( 2 * J_1*(p) ) / p  ]
% I_0 is the intensity of the wave
% J_1 is the bessel function of the first kind, 
% k = 2pi/lambda is the wavenumber
% a is the radius of aperture
% theta is the angle of observation

clc
close all
clear all
format

%I =@(theta) I_0 * [  ( 2 * J_1*(p) ) / p  ]

rho = [0:0.1:10];

I_0 = 1;
I = I_0*(2*besselj(1,rho)./rho).^2

figure(1)
plot(rho,I/I_0)
title('Plot of $$\frac{I}{I_0}$$','interpreter','latex')
xlabel('z')
ylabel('$$\frac{I}{I_0}$$','interpreter','latex')

% Rho 1-10 estimation
rho = 0:10; % reassign rho with integer values only
for n = 0:10
    J(n+1,:) = besselj(n,rho);
end

figure(2)
plot(rho,J)
title('Estimation with \rho = 1:10')
xlabel('\rho')
ylabel('J')

% Automated feedback script
test='Brooks_6_1.m';
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
url = ['mailto:',email];
web(url)