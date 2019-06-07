% Bifurication II
% Kai brooks
% 24 Apr 2019
% Description
%
% Calculates the Feigenbaum constant

clc
close all
clear all
format

a_0 = 2; 
a1 = 1 + sqrt(5); 
d  = 4;

mu(1) = a_0;
mu(2) = a1;

for k = 3:5
    a = a1 + (a1-a_0)/d; %aprox inicial
    for i = 1:2
        res = 0.5; 
        der = 0;
        for j = 2:2^(k-1)+1
           der = res*(1-res) + a*(1-2*res)*der;
           res = a*res*(1-res);
        end
        a = a - (res-0.5)/der;
    end
    
    d = (vpa(a1)-vpa(a_0))/(vpa(a)-vpa(a1)); 
    fprintf('Number %u: %.15f\n', k, double(d));
    a_0 = a1; a1 = a;
    mu(k) = a;
end

% Automated feedback script
test='filename.m';
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
url = ['mailto:',email];
web(url)