% Weighted least squares demo
% 22 Apr 2019

clc
clear all
close all

d=load('data/erdinger_weiss.txt');
t=d(:,1);
h=d(:,2);
s=d(:,3);

y=log(h);
s=s./h;

x=t;
g=sum(1./s.^2)*sum(x.^2./s.^2)-sum(x./s.^2)^2;
a=( sum(x.^2./s.^2)*sum(y./s.^2)-sum(x./s.^2)*sum(x.*y./s.^2))/g;
b=( sum(1./s.^2)*sum(x.*y./s.^2)-sum(x./s.^2)*sum(y./s.^2) )/g;
plot(x,y,'m*',x,polyval([b a],x))

