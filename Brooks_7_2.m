% Integration I
% Kai brooks
% 16 May 2019
% Description
%
%Integrate sin(x) from 0 to pi using trapezoidal, Simpsonís, and Simpsonís 3/8th rules, using your code.  
%The answer is 2.  Compare accuracy of the various methods with equal number of function evaluations, 
%so you could plot, for the various rules, the result minus 2 vs the number of evaluations. 

clc
close all
clear all
format


N = 2.^[4:10];
f = @(x) sin(x);
for i=1:numel(N)
x = linspace(0,pi,3*N(i)+1);
y = f(x);
% simpsons_3_8 = (3*h./8)*(f_0+3*f_1+3*f_2+f_3); 
h=pi/(3*N(i));
int{1}(i)=trapz(x,y);
int{2}(i)= (h/3)*(y(1)+2*sum(y(3:2:end-2))+4*sum(y(2:2:end))+y(end));
int{3}(i)= (3*h/8)*(y(1)+3*sum(y(2:3:end))+3*sum(y(3:3:end))+2*sum(y(4:3:end-1))+y(end));
end

for k = 1:3
subplot(3,1,k);
loglog(3*N,int{k}-2);
xlim([3*N(1) 3*N(end)]);
xlabel('N');
ylabel('error');
grid on
end
subplot(3,1,1);
title('Trapezoidal Rule Errors');
subplot(3,1,2);
title('Simpsons Rule Errors');
subplot(3,1,3);
title('Simpsons 3/8 Rule Errors');

% Automated feedback script
test='Brooks_7_2.m';
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
url = ['mailto:',email];
web(url)