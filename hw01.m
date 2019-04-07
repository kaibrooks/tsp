% Script name
% Kai brooks
% What it does

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

% Generate array of random numbers
a = randperm(arrayInterval,arrayLength)

% Set baseline number
largestNum = 0;

for n=1:arrayLength
    if a(n) > largestNum
        largestNum = a(n);
    end
end

largestNum