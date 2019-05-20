% Random II
% Kai brooks
% 20 May 2019
% Description
%
% Find the odds of two people sharing the same birthday in a set of n
% people

clc
close all
clear all
format

setSize = 30;  % number of integers to generate
epochs = 1000;

loops = 0;  % timing calculation
found = 0; % break loop
totalMatches = 0;



for int = 1:epochs
    x = randi([1 365],[setSize 1]) % generate k random integers
    
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

totalMatches/epochs


% Automated feedback script
% test='Brooks_8_1.m';
% str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
% email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
% url = ['mailto:',email];
% web(url)