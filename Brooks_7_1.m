% Derivatives
% Kai brooks
% 16 May 2019
% Plot the forward, backward, and central approximations of the 
% derivative of ?(?) = 1000 exp (?/17) at ? = 3.2, for values of 
% ? = 0.01 to 5, in steps of 0.05. Compare with the correct value.

clc
close all
clear all
format



f=@(x)1000*exp(x/17);
X=3.2;
h=[0.01:0.05:5];
y=zeros(4,length(h));

for k=1:length(h)
    y(1,k)=((1000/17)*exp(X/17));
    y(2,k)=(f(X+h(k))-f(X))/h(k);
    y(3,k)=(f(X+(h(k)./2))-f(X-(h(k)./2)))/h(k);
    y(4,k)=(f(X)-f(X-h(k)))/h(k);
end

plot(h,y)
legend('Actual Value','Forward Derivitive','Central Derivitive','Backward Derivitive')

% Automated feedback script
test='Brooks_7_1.m';
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
url = ['mailto:',email];
web(url)