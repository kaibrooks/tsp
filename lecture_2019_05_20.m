% Birthday checker
% Kai brooks
% 20 May 2019
% Description
%
% Find odds of two people sharing the same birthday in a set of n people

clc
close all
clear all
format

setSize = 50;  % number of integers to generate
epochs = 100;
iterations = 100; % how far to plot

loops = 0;  % timing calculation
found = 0; % break loop
totalMatches = 0;

for i = 1:iterations
    for int= 1:epochs
        x = randi([1 365],[setSize 1]); % generate k random integers
        
        for n=1:setSize-1
            for m=1+n:setSize-1
                
                if x(n) == x(m)
                    %fprintf('found on day %i \n',x(n))
                    found = 1;
                end
                
                loops = loops+1;
                
                if found == 1
                    break
                end
            end
            
            if x(n) == x(m)
                %fprintf('found on day %i \n',x(n))
                found = 1;
            end
            
            if found == 1
                break
            end
        end
        
        % add total if found
        if found==1
            totalMatches = totalMatches+1;
        end
        
        found = 0;
        
    end
    
    prob(i,1) = totalMatches/epochs;
    prob(i,2) = i;
    
end


% Automated feedback script
% test='Brooks_8_1.m';
% str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
% email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
% url = ['mailto:',email];
% web(url)