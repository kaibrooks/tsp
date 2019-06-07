clc
clear all
close all

rng('default')

% copy over vars
maxCities = 8;               % maximum number to store
startingCity = 1;            % starting city (chosen randomly)

% ga vars
%wordLength = 4;              % how many bits used to store a number
%dataSize = 2^wordLength;     % maximum storable number (can't have more cities than this)

%dnaLength = wordLength * maxCities; % how long to make the dna, one word per city

initPopSize = 5;

% ---------- create intial population
% create dna
tic

% create genes
linearPath = [1:maxCities];

for i=1:initPopSize
    dnade(i,:) = linearPath(randperm(length(linearPath)));
end

dnade

% shift matrix so starting city is correct
for i=1:initPopSize
    k = find(dnade(i,:) == startingCity);
    dnade(i,:) = circshift(dnade(i,:), (maxCities+1) - k);
end

% add city onto the end so it loops


dnade



% for i = 1:initPopSize
%     dnabi(i,:) = round(rand(1,dnaLength)); % dna with word length = maxCities
%     % dna stored by (i,j), where i = genotype (entire thing), j = chromosome (bit)
%     clc
%     fprintf('\n')
%     fprintf('Generating %i more population...\n',initPopSize-i)
% end
% popGenTime = formatTime(toc);
% fprintf('Population generated in %s\n',popGenTime)
%
% dnabi;
%
% % convert DNA into number for pathing
% tic
% fprintf('Converting genes to path order...\n')
% for k = 1:initPopSize           % population
%     for j = 1:maxCities         % genotype
%         for i = 1:wordLength    % word
%             temp(i) = dnabi(k, i+((j*wordLength)-wordLength) );
%         end
%         dnade(k,j) = bi2de(flip(temp)); % flip so the lsb is the rightmost bit
%         clear temp;
%     end
%     clc
%     fprintf('Population generated in %s\n',popGenTime)
%     fprintf('Generating %i more genes paths...\n',initPopSize-k)
%
% end
%
% fprintf('Path order generated in %s\n',formatTime(toc))
%
% dnade;

% dnade = dnade+1; % how to add 1 for route calculation

% --- wipe out all invalid genes

% Determine if rows have duplicate entries (and are thus invalid)
uniqueEntries = 0;
for i = 1:initPopSize
    a = dnade(i:i,:);
    if length(a) == length(unique(a))
        %fprintf('%i: unique\n',i)
        uniqueEntries = uniqueEntries + 1;
    else
        %fprintf('%i: not unique\n',i)
    end
end

uniqueRatio = uniqueEntries / initPopSize;

fprintf('%i valid genotypes: %.2f%%',uniqueEntries, uniqueRatio*100)




%if length(v) == length(unique(v)) -- no repeats

% delete row 3 and 9: A([3,9],:) = [];

% select for best

% s