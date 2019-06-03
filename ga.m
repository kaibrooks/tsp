clc
clear all
close all

rng('default')

% copy over vars
maxCities = 10;               % maximum number to store

% ga vars
wordLength = 4;              % how many bits used to store a number
dataSize = 2^wordLength;     % maximum storable number (can't have more cities than this)


dnaLength = wordLength * maxCities; % how long to make the dna, one word per city

initPopSize = 10;

% create intial population
% create dna

tic

for i = 1:initPopSize
    dnabi(i,:) = round(rand(1,dnaLength)); % dna with word length = maxCities
    % dna stored by (i,j), where i = genotype (entire thing), j = chromosome (bit)
    clc
    fprintf('\n')
    fprintf('Generating %i more population...\n',initPopSize-i)
end
popGenTime = formatTime(toc);
fprintf('Population generated in %s\n',popGenTime)

dnabi;

% convert DNA into number for pathing
tic
fprintf('Converting genes to path order...\n')
for k = 1:initPopSize           % population
    for j = 1:maxCities         % genotype
        for i = 1:wordLength    % word
            temp(i) = dnabi(k, i+((j*wordLength)-wordLength) );
        end
        dnade(k,j) = bi2de(flip(temp)); % flip so the lsb is the rightmost bit
        clear temp;
    end
    clc
    fprintf('Population generated in %s\n',popGenTime)
    fprintf('Generating %i more genes paths...\n',initPopSize-k)
    
end

fprintf('Path order generated in %s\n',formatTime(toc))

dnade;
%dnade = dnade+1; % how to add 1 for route calculation

% wipe out all invalid genes
dnade


% select for best

% s