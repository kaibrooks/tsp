% Roots III
% Kai brooks
% 2 May 2019
% Description
%
% Using Newton-Raphson, find the smallest positive root of the ninth 
% Legendre polynomial: 1/128 (12155x^9 - 25740x^7 + 18018x^5 - 4620x^3 + 315x).
% These polynomials are defined by P_n(x) = 1/(2^n*n!) * d^n/dx^n * [(x^2 - 1)^n].
% See: http://en.wikipedia.org/wiki/Legendre_polynomials. 
% They appear in the solution of the wave function of the hydrogen atom.

clc
close all
clear all
format

eps = 1E-15; % error threshold
x = zeros(4,20);
for m = 1:4
    x(m,1)=1;   % starting 1 and 2 values
    x(m,2)=2;
    for n=3:15   % bisection method gets to 10^-10 in 30 iterations, this should be faster
        
        x(m,n)=x(m,n-1)-Brooks_5_2f( m,x(m,n-1) )*( x(m,n-1)-x(m,n-2) )/( Brooks_5_2f( m,x(m,n-1) )- Brooks_5_2f( m,x(m,n-2) ) )               
        
        if abs(x(m,n)-x(m,n-1)) < eps
            break;
        end
  
    end
    y=0;
    for k=1:n
        y(k)=x(m,k);
%         if abs(x(m,k)) > 1E-16
%             y(k) = x(m,k);
%         end
    end
    subplot(2,2,m)
    %plot(x(m,:))
    plot(y)
end

% Automated feedback script
test='Brooks_5_3.m';
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
url = ['mailto:',email];
web(url)