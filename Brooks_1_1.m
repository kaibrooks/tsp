% Max Finder
% Kai brooks
% 8 Apr 2019
% Finds the maximum value of an element of an array
%
% Label your submission as follows: ?Lastname_1_1.m? Suppose you have an
% array or matrix with numbers.  Find the maximum value in that array and
% which element has the maximum value.  How would you do that?  Now do it
% the hard way, using for loops.  This is assignment 1 of the first
% homework set.  You can generate arrays by using rand( 10 ), magic( 4 ),
% or any other way you feel like.

clc
close all
clear all

arrayLength = 10;
arrayInterval = 100;

a = randperm(arrayInterval,arrayLength) % Generate random array

largestNum = 0; % Set baseline number

for n=1:arrayLength
    if a(n) > largestNum
        largestNum = a(n);
    end
end

largestNum

% Automated feedback script
test=Brooks_1_1.m;
str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: '; 
email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str ); 
url = ['mailto:',email]; 
web(url)