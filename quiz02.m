clc
close all
clear all

% Give two different ways to construct a 1000-by-1000 matrix containing all
% zeros except for having ones all along the northeast-to-southwest diagonal

matrixSize = 5;

% Method 1
for n=1:matrixSize
    for m=1:matrixSize
        if n == m
            a(n,m) = 1;
        else
            a(n,m) = 0;
        end
    end
    
end

a;

% Method 2
for n=1:matrixSize
    for m=1:matrixSize
        b(n,m) = 0;
    end
end

for n=1:matrixSize
    b(n,n) = 1;
end

b;


% Check if all elements in a matrix are composite (not prime)

if sum(isprime([2 3 0 6 10])) > 0
    allComposite = 0;
else
    allComposite = 1;
end

allComposite