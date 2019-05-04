% Roots I
% Kai brooks
% 2 May 2019
% Description
%
% Using bisection, find the root for x^3 = 169  Or, alternatively,
% f(x) = x^3 - 169.  What the brilliant thing leads that we will have
% determined the cuberoot(169) without taking the root!

clc
close all
clear all
format

f=@(x) x^3- 169; %eq to check

floor = 1;  % bottom number to check
ceil = 10;  % top number to check
eps = 1E-12; % acceptable error

bisection(f, floor, ceil, eps);

% Automated feedback script
test='Brooks_5_1.m';
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
url = ['mailto:',email];
web(url)

% Bisection function
function m = bisection(f, floor, ceil, eps)

% Evaluate upper/lower bounds
bLower = feval(f, floor);
bUpper = feval(f, ceil);
n = 0;
maxEpochs = 100; % max epochs so we don't loop forever

% Check for negativity
if bLower * bUpper > 0
    disp('Error: No change in sign (try widening bounds)');
    return
end

while (abs(ceil-floor) >= eps)
    n=n+1;
    
    m = (ceil + floor)/2;   % Divide the ceiling by half to check for roots in this area
    y = feval(f, m);
    if y == 0   % If we find a root exactly, output it
        fprintf('Root found: x = %f \n\n', m);
        return
    end
    
    fprintf('%3i: %f \n', n-1, m);
    
    
    % Update bounds
    if bLower * y > 0
        floor = m;
        bLower = y;
    else
        ceil = m;
    end
    
    if n > maxEpochs
        fprintf('No estimation within specified error in %i epochs', maxEpochs);
        return
    end
        

end


fprintf('Found after %i epochs\n', n-1);
fprintf('Estimated x = %f\n',m)


%f(x) = %f \n %i iterations\n', m, y, n-1);
%fprintf(' Approximation with eps = %f \n', eps);

end