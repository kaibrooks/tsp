% Title
% Kai brooks
% 10 May 2019
% Description
% 

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

% Create airy pattern
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

y = [0:10]
% Estimate with cubic splines
f=@(x) (2*besselj(1,x)./x).^2;
x=0:10;
x(1)=1E-6;
plot(x,f(x),'kx')
hold on
fplot(f,[0 10])

xf=0:.01:10;
plot(xf,spline(x,f(x),xf))   

% Estimate with linear approximation
p = polyfit(x, f(x), 1);
y_fit = polyval(p, x);
plot(y,y_fit)

% Estimate with quadratic approximation
p = polyfit(x, f(x), 2);
y_fit = polyval(p, x);
plot(y,y_fit)

firstmin = fminbnd(f, 0,10)

fprintf('First dark point at minimum, %f',firstmin)



title('Estimation with different interpolations')
xlabel('\rho')
ylabel('J')

% Automated feedback script
%test='Brooks_6_2.m';
%str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
%email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
%url = ['mailto:',email];
%web(url)