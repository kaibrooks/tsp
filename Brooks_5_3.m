% Roots III
% Kai brooks
% 8 Apr 2019
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



% Automated feedback script
% test='filename.m';
% str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
% email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
% url = ['mailto:',email];
% web(url)