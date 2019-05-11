% Title
% Kai brooks
% 8 Apr 2019
% Description
%

clc
close all
clear all
format

f=@(x) (2*besselj(1,x)./x).^2;
x=0:10;
x(1)=1E-6;
plot(x,f(x),'kx')
hold on
fplot(f,[0 10])

xf=0:.01:10;
plot(xf,spline(x,f(x),xf))   

figure
plot(xf,f(xf)-spline(x,f(x),xf)) % Plot difference between spline and function

% Spline fits a cubic polynomial between points and makes derivitive at
% each point continuous. Requires 4 constants


f(x)