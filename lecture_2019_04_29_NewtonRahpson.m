% Newton Rahpson method
% Kai brooks
% 2019 April 29
% Newton Rahpson method
%
% NR: x^2+1
% Derivative 2x
% x_i = 1/sqrt(3)

clc
close all
clear all
format

f=@(x)x.^2-1;   % Declare function
d=@(x)2*x;      % Derivative
x = 1/sqrt(3);
for n=1:8
    %x=x-f(x)/d(x);
    %y(n) = n;   % for plotting
    %z(n) = x;   % for plotting
end

xp=Inf;

while abs(x-xp) > 1E-10
    xp=x;
    x=x-f(x)/d(x)
    abs(x-xp) 
end

%plot(y,z);

% if you dont know if there's a root, plot it

g=@(x)3*x^2 + ((ln(pi-x))^2 / (pi^4)) + 1;