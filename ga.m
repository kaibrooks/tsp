clc
clear all
close all

% copy over vars
maxCities = 4;

% ga vars
wordLength = 4;              % how many bits used to store a number
byteSize = 2^wordLength;     % maximum storable number (can't have more cities than this)

dnaLength = wordLength * maxCities; % how long to make the dna, one word per city

initPopSize = 1;

% create intial population
% create dna

for i = 1:initPopSize
    dna(i,:) = round(rand(1,dnaLength)); % dna with word length = maxCities
    % dna stored by (i,j), where i = genotype (entire thing), j = chromosome (bit)
end

dna

% convert DNA into number for pathing
for j = 1:4
    for i = 1:4
        temp(i) = dna(1,i+ ((j*4)-4) );
    end
    temp
    dnade(j) = bi2de(flip(temp)); % flip so the lsb is the rightmost bit
end

dnade



% need a bit to


% select for best

% s