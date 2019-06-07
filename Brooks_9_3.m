% Pendulum II
% Kai brooks
% 31 May 2019
% 
% solve diff(y,t) = y^2 + 1 using RK4

clc
close all
clear all
format

g = 9.8;
l = 1;
a = 1;
q = 1;

% Direct solve
syms a y(t)
fd = diff(y,t) == (-g/l)*a - q*diff(a,t)
dsolve(fd)

step = 1E-4;
theta = 0:step:pi/2;

h = 0.5; 
t_f = 5;
t = 0:h:t_f;                
y = zeros(1,numel(t)); % length of t
y(1) = 0; % y(0) but with a shifted indexing

for k = 1:length(theta);
    f=@(x,t) 1./sqrt(1.-(sin(theta(k)).*sin(x)));
    k1 = h * f(t(i-1), y(i-1)); % compute first 4 k's
    k2 = h * f(t(i-1)+ h/2, y(i-1) + k1/2);
    k3 = h * f(t(i-1)+ h/2, y(i-1) + k2/2);
    k4 = h * f(t(i-1) + h, y(i-1) + k3);
    y(i) = y(i-1) + (k1+ 2*k2 + 2*k3 +k4)/6;    % write y
    p(k,1) = integral(@(x)f(x),0,pi/2);
    p(k,2) = theta(k);
end




T = 4*p(:,1);

plot(p(:,2),T);
xlabel('\theta');
ylabel('T');
grid on

% Automated feedback script
test='Brooks_9_3.m';
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
url = ['mailto:',email];
web(url)