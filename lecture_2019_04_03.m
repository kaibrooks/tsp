% Kai Brooks
% 2019-04-03
% Class covers basic MATLAB commands, entering data into matrices and
% arrays

% Cmd+i autoindents

clc
close all
clear all

% a=magic(3)
% b=a*2
% c=a.^2
% b(2,:)=0

% Assign values to a matrix
for n=1:5
    for m=1:5
        if n == 3
            a(n,m) = 0;
        else
            a(n,m) = n+m;
        end
    end
    
end

a

% Assign values to a matrix without an if statement
for n=1:2
    for m=1:5
        b(n,m) = n+m;
    end
    
end

for m=1:5
    b(3,m) = 0;
end

for n=4:5
    for m=1:5
        b(n,m) = n+m;
    end
    
end

b

% Assign values to a matrix without an if statement part 2
for n=1:5
    for m=1:5
        c(n,m) = n+m;
    end
end

c(3,:) = 0;


c
