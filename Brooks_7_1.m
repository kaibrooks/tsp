% Derivatives
% Kai brooks
% 16 May 2019
% Description
%
% Plot the forward, backward, and central approximations of the derivative
% of f(x) = 1000*exp(x/17) at x=3.2, for values of h=0.01 to 5 in steps of
% 0.05. Compare with the correct value.

clc
close all
clear all
format

h = 0.01;
x = linspace(0,10); % Set bounds for plotting

f = @(x) 1000*exp(x/17)

f_x = f(x);       % set f(x) to use in plots
for (h = 0.01:5:0.05);
    
    % forward approx
    x_f = x(1:end-1);
    df_f = (f_x(2:end) - f_x(1:end-1))/h;
    
    
    % center approx
    x_c = x(2:end-1);
    df_c = (f_x(3:end)-f_x(1:end-2))/(2*h);
    
    % backward approx
    x_b = x(2:end);
    df_b = (f_x(2:end)-f_x(1:end-1))/h;
    
    hold on
    plot(x_f,df_f); % forward
    plot(x_b,df_b); % backward
    plot(x_c,df_c)  % central
    grid on
    axis tight
    legend('Forward','Backward','Central')
    
end

% exact value
a = f(3.2)
fprintf('Compare to exact value: %f\n', a)

% Automated feedback script
test='Brooks_7_1.m';
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
url = ['mailto:',email];
% web(url)