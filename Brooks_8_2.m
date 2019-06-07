% 8.2
% Kai brooks
% 24 May 2019
% Description
%
% I = int(,0,1)_1 * int(0,1)_2 ... int(0,1)_10 * (x_1 + x_2 +...x_10)^2
% and estimate the error

clc
close all
clear all
format

syms func

% for x_1 = 1, x_2 = 2, x_n = n
% integrate
a = 1;
for n=1:10
    func = @(x) x*n;    
    a = a * integral(func,0,1);
end

% multiply
b = 0;
for n=1:10
    b = b+n;
end
b = b^2

% combine
ans = a*b

% Automated feedback script
test='Brooks_8_2.m';
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
url = ['mailto:',email];
web(url)