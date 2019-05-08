%
% Kai brooks
% 2019 May 01
%
% f(x) = x^m - 169 ; m=2...5
% nested loops
% function -> brooks_1 (m,x)
% plots -> for each m, plot x_n
% 1 figure, 4 subplots
% if statements
%
% secant: x_n+1 = x_n - f(x_n)* [( x_n - x_n-1 ) / ( f(x_n) - f(x_n-1) )]

clc
close all
clear all
format

% x(4, 2) % (m,n)
% 
% eps = 10^-6;
% for m=1:4
%     for n=3:30  % bisection gets to 10^-10 in 30 iterations; this should be faster
%         x^m(n) = x^m(n-1) - f(x^m_n-1) * [(x^m(n-1) - x^m(n-2) / f(x^m(n-1)) - f(x^m n-2)]
%             
%         if abs(x_m,n - x_m,n-1) < eps 10^3 % if below some error threshold
%         break
%         end
%         
%     end
% end

eps = 1E-6; % error threshold
for m = 1:4
    x(m,1)=1;   % starting 1 and 2 values
    x(m,2)=0;
    for n=3:30 % bisection method gets to 10^-10 in 30 iterations, this should be faster
        x(m,n)=x(m,n-1)-f(m,x(m,n-1)*(x(m,n-1)-x(m,n-2)/(f(m,x(m,n-1)-f(m,x(m,n-2))));
        if abs(x(m,n)-x(m,n-1)) < eps
            break;
        end
    end
    subplot(2,2,m)
    plot(x(m,:))
end


