% Least Squares
% Kai brooks
% 17 Apr 2019
% Description
%
% Generate data using y=17-3*x+rand() for 10 values of x from 1 to 9. Plot 
% the data and the fit (y fitted to x) to this data. Assume all x's are 
% known exactly and the uncertainty in the various y's is all the same.
% Use
% the same data (i.e., do not recalculate the y's!) and now assume that y's
% are known exactly and the uncertainty is only in the various x's and this
% uncertainty is all the same. Do this fit. Plot this fit (x fitted to y) 
% on the same graph. So, the end result is one graph with the 'experimental
% data' and two fits. One fit of x vs y and one y vs x, but make sure that 
% the x is always on the x-axis and the y is on the y-axis. Does it make 
% sense that the curve fits are not exactly the same? Display your answer. 
% Use polyfit to get the intercept and slope of the straight line.

clc
close all
clear all
format
rng(3416)       % maintain seed for testing

% Generate random data
for n=1:10
    y(n)=17-3*n+rand();
    x(n) = n;   % Make a 1:n vector
end

px = polyfit(x,y,1);
py = polyfit(y,x,1);

x1 = x;
y1 = polyval(px,x1);

x2 = polyval(py,y);
y2 = y;

fprintf('Linear fit characteristics for independent x \n')
fprintf('Slope: %f | Intercept: %f \n', px)

fprintf('Linear fit characteristics for independent y \n')
fprintf('Slope: %f | Intercept: %f ', py)

hold on

figure(1)
%plot(p)
plot(x, y, 'o')
plot(x1, y1, 'Color', '[0.4940 0.1840 0.5560]')
plot(x2, y, 'Color', '[0.4660 0.6740 0.1880]')

xlabel('\it x')
ylabel('\it y')
legend('given','fit x', 'fit y')
axis tight




% Automated feedback script
test='Brooks_3_1.m';
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
url = ['mailto:',email];
web(url)