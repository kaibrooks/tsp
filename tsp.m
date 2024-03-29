% TSP 3-way
% Kai Brooks
% github.com/kaibrooks
% Jun 2019
%
% Computes the travelling salesman problem three different ways.
% https://en.wikipedia.org/wiki/Travelling_salesman_problem
%
% Readme:
%   Options are below. Basic options enable/disable various algorithms,
%   advanced options modify generator settings and adjust various selection /
%   computation parameters with often unexpected results, and will likely not
%   function correctly for numbers vastly outside their defaults.
%
% Algorithm basics:
%   Bruteforce (green)-
%   Computes every possible combination of routes, finds the shortest. This
%   method is impractical or impossible for n > ~12 (ie, n=14 requires
%   42.8GB of RAM and takes a few days to compute). This method does not
%   use any sort of dynamic/parallel programming or other shortcuts. This
%   method will always produce the correct (best possible) solution.
%
%   Nearest-neighbor (red)-
%   Finds closest point to current point, loops back to start at end. If
%   gifoutput, this method plots 'decision lines' as well.
%
%   Genetic Algorithm (blue)-
%   Attemps many possible routes, takes the best of those and tries
%   again with a new set of similar routes. Take note of the performance
%   change by generation plot upon completion, it notes approximately how
%   many iterations of the GA will be needed to outperform NN.
%   Note: Genetic algorithm may produce unforseen errors when its settings
%   are drastically different from defaults, and the program will not check
%   for validity before attemping to run them.
%
% Use cases:
%   By default, this program will run n=9, which allows for all three
%   algorithms to run.
%
%   For more intersting applications of the NN/GA algorithms, use n > ~25
%   (and disable the BF, unless you have 10^15 gigabytes of RAM and 10^13
%   years to wait).
%   At n > ~60, the computational complexity exceeds the number of atoms in
%   the universe, and would take about 10^70 years to solve.
%
%   Many variables are set by default in the range of what a 2.3GHz i7 CPU
%   from 2013 can compute within reasonable time.


% Init
clc
close all
clear all
format
rng('shuffle')


%% --- Options ------------------------------------------------------------
%  --- Main Options -------------------------------------------------------
maxCities = 9;          % (default 9) number of cities to visit, this is the 'n'
gifOutput = 1;          % enables gif output and generation, slows rendering
filename = 'tsp.gif';   % output filename for the gif
verbose = 0;            % (default 0) outputs a pile of text while running

% Algorithm enables (with all disabled, just generates the map)
bf = 1;                 % bruteforce algorithm
nn = 1;                 % nearest-neighbor algorithm
gena = 1;               % genetic algorithm

% genetic algorithm selection processes
gaRandomCrossover = 0;  % (default 0) random crossover variant, hangs with too large n
gaOrderedCrossover = 1; % (default 1) ordered crossover variant

% --- Plot and display settings -------------------------------------------

plotScale = 10;         % (default 10) size of markers on map
showLabels = 1;         % (default 1) display city numbers on plot

outputResults = 1;      % (default 1) shows analysis at completion

% --- Advanced options and generator settings -----------------------------


minLoc = 1;             % (default 1) minimum coordinate to generate for city locations
maxLoc = 100;           % (default 100) maximum coordinate to generate for city locations

gaSelectionFactor = 2;  % (default 2) fractional number of members to select each epoch (eg: 3 = 1/3 of members)
gaInitPopSize = 100;    % (default 100) population for genetic algorithm
gaMutationRate = 0.01;  % (default 0.01) mutate this portion of the population (0.01 = 1%)
gaMaxGenerations = 500; % (default 500) number of times ga generates new pop
gaElitism = 0.2;        % (default 0.2, max 0.4) elitism, in %. 0 to disable

bfTickSize = 10000;     % (default 10000) tick size for timing BF algorithm. Higher numbers = more accuracy, slower to display estimate

attempts = 100;         % number of attempts to bruteforce the solution before giving up
maxCpuTime = 100;       % max loops various functions will use before giving up and moving on

% --- Init other variables (do not modify) --------------------------------

totalDist = 0;          % total distance travelled
gifWritten = 0;         % one-time check for gif creation

o_nn = 0;               % o for nearest neighbor method
o_bf = 0;               % o for bruteforce method
o_ga = 0;               % o for genetic method
nn_distance = 0;        % total minimum distance
bf_distance = 0;
ga_distance = 0;
bf_time = 0;            % time to run algorithm
nn_time = 0;
ga_time = 0;

nnSecs = 0;
bruteforce_minimum_vec = 0;

%% --- Program start ------------------------------------------------------

% Generate points
cities = randi([minLoc, maxLoc],2,maxCities); % generate matrix
cities = rot90(cities);  % rotate to form cities(x1,y1) for each point
cities = unique(cities,'rows'); % remove duplicate entries

if (length(cities) ~= maxCities)
    fprintf('*** Generated duplicate city coordinates, pruning %i entries.\n*** New maxCities = %i \n', maxCities - length(cities), length(cities))
end

maxCities = length(cities);  % shorten everything else if we don't have enough cities


startingCity = randi(maxCities);    % randomize starting city
currentCity = startingCity;         % and remember its where we started

visited = zeros([maxCities],1);     % boolean to mark each visited city
visited(currentCity) = 1;           % we're already in our city, so mark it

visitedOrder = zeros([maxCities],1); % vector to store the order which we visited each city
visitedOrder(currentCity) = 1;      % mark out starting city on the path

% Create figure
f = figure('Name','Stacked Routes','units','normalized','NumberTitle','off');%,'outerposition',[0 0 1 1]);
axis tight manual % this ensures that getframe() returns a consistent size

titleStr = '';
s1 = '';
s2 = '';
s3 = '';

if bf, s1 = 'Green: BF- ';, end
if nn, s2 = 'Red: NN - ';, end
if gena, s3 = 'Blue: GA';, end

titleStr = strcat(titleStr, s1, s2, s3);
title(titleStr);

clear s1, clear s2, clear s3

xlabel('Latitude')
ylabel('Longitude')

hold on
grid on

xlim([minLoc maxLoc])
ylim([minLoc maxLoc])

txt = '    \leftarrow Start';

% Plot cities
for i=1:maxCities
    
    if i == startingCity
        plot(cities(i,1),cities(i,2),'bo','MarkerSize',plotScale)
        
    else
        plot(cities(i,1),cities(i,2),'k^','MarkerSize',plotScale)
    end
    if showLabels, text(cities(i,1),cities(i,2),sprintf('   %i', i)), end
    
end

txt = '    \leftarrow Start';
text(cities(startingCity,1),cities(startingCity,2),txt)

% --- Algorithms ----------------------------------------------------------

%% Bruteforce algorithm (bf)
if bf
    fprintf('Generating bf pathing matrix...\n')
    % Create gigantic bruteforce path matrix: o(n!)
    arr = [2:maxCities];
    bfVisitOrder = perms(arr);
    bfVisitOrder = rot90(bfVisitOrder); % flip it to make indexing easier
    
    arr = ones(1,length(bfVisitOrder)); % create array of 1's
    bfVisitOrder = [arr;bfVisitOrder];  % append to the beginning
    
    % Add original city back onto end to complete the loop
    for i = 1:length(bfVisitOrder)
        bfVisitOrder(maxCities+1,i) = bfVisitOrder(1,i);
    end
    
    bf_omax = numel(bfVisitOrder); % get total size of matrix
    bfEstimatedTime = 0;    % zero the estimation before starting the loop
    %minDist = maxLoc^2;  % starting minimum distance
    % while sum(visited) < maxCities
    
    for j=1:length(bfVisitOrder)
        o_bf = o_bf + 1;
        
        if j==1,tic,end % start the clock on 2
        
        for i=1:maxCities
            o_bf = o_bf + 1;
            
            a = [cities(bfVisitOrder(i,j),1),cities(bfVisitOrder(i,j),2)];
            b = [cities(bfVisitOrder(i+1,j),1),cities(bfVisitOrder(i+1,j),2)];
            
            checkDistance = [a;b]; % select two points
            distance = pdist(checkDistance,'euclidean');   % find distance between them
            %distance = floor(distance); % truncate
            totalDist = totalDist + distance;
            
            bfSegmentDistances(i,j) = distance;
            
        end
        
        if j==bfTickSize
            timing = toc;
            bfEstimatedTime = timing*(length(bfVisitOrder)/bfTickSize) % timing*((length(bfVisitOrder)-bfTickSize)/bfTickSize) for 'time remaining as of this timing'
            bfTimeTicks = length(bfVisitOrder)/bfTickSize;
        end
        
        bfDistances(j) = totalDist; % store the total path length
        totalDist = 0;              % reset for the next run
        
        % Output running information
        if ~verbose
            clc
            fprintf('Starting BF for n=%i, O(n!)=%i \n',maxCities, bf_omax)
            
            if length(bfVisitOrder) > bfTickSize % only display if enough data to estimate
                if bfEstimatedTime > 0
                    fprintf('Estimated runtime: %s\n',formatTime(bfEstimatedTime))
                else
                    fprintf('Estimated runtime: (Sampling %i more times..)\n',bfTickSize-j)
                end
            end
            fprintf('Current runtime  : %s\n',formatTime(toc))
            fprintf('Computing optimal route... %.2f%% \n', (o_bf / bf_omax) * 100)
        end
        
    end % end of loop
    
    % Find min value
    [bfMinDist,bfMinIndex] = min(bfDistances);
    %bruteforce_path_taken = bfVisitOrder(:,bfMinIndex)
    
    %min(bfDist)
    %bfDist(j)
    
    %bfDist
    %     bfMinIndex
    %     bfDistances(bfMinIndex)
    bf_distance = bfMinDist;    % save for comparison
    
    % Plot it
    for i=1:maxCities
        
        a = [cities(bfVisitOrder(i,bfMinIndex),1), cities(bfVisitOrder(i,bfMinIndex),2)];
        b = [cities(bfVisitOrder(i+1,bfMinIndex),1), cities(bfVisitOrder(i+1,bfMinIndex),2)];
        
        x = [a(1), b(1)];
        y = [a(2), b(2)];
        plot(x,y,'g','LineWidth',plotScale/6)
        
        
        %bfVisitOrder(i:4,bfShortest) gives path
        
    end
    bfSecs = toc;
    if bfSecs > 0
        hours = 0;
        mins = 0;
        secs = 0;
        
        mins = floor(bfSecs / 60);
        secs = (rem(bfSecs, 60));
        
        if mins > 60
            hours = floor(mins / 60);
            mins = mins - (hours*60);
        end
        
        bf_time = sprintf('%ih%im%.0fs',hours,mins,secs); % format time
    end
    
    %fprintf('BF method complete in %.2f seconds\n', toc)
end

% Clear variables between runs
totalDist = 0;
minDist = 0;

%% Nearest Neighbor Algorithm
if nn
    fprintf('Computing nearest neighbor route...\n')
    for j = 2:maxCities
        if j==2,tic,end % start the clock on 2
        
        o_nn = o_nn + 1;
        
        ccLoc = [cities(currentCity,1), cities(currentCity,2)]; % coords of current city
        
        minDist = maxLoc^2;   % starting distance, make maximum possible
        
        for i = 1:maxCities
            o_nn = o_nn + 1;
            
            if visited(i), continue, end % skip cities we've visited
            
            a = ccLoc;  % current city coordinates
            b = [cities(i,1),cities(i,2)];
            
            checkDistance = [a;b]; % select two points
            
            distance = pdist(checkDistance,'euclidean');    % find distance between them
            
            % Draw decision lines
            if gifOutput
                % Draw 'decision' line
                x = [cities(currentCity,1), cities(i,1)];
                y = [cities(currentCity,2), cities(i,2)];
                
                h = plot(x,y,'c:','LineWidth',plotScale/6);
                uistack(h,'bottom');
                
                drawnow
                % Capture the plot as an image
                %title("" + o_nn)
                if  gifWritten == 0
                    gifWritten = 1;
                    gif(filename,'DelayTime',0.01,'LoopCount',1,'frame',gcf)
                else
                    gifWritten = 1;
                    gif
                end
            end
            
            if distance < minDist
                minDist = distance;
                nextCity = i;
                nextLoc = [cities(i,1),cities(i,2)];
            end
            
            
        end
        
        if j == maxCities+1
            a = [cities(maxCities,1),maxCities(2)];  % current city coordinates
            b = [cities(1,1),cities(1,2)];
            
            checkDistance = [a;b]; % select two points
            distance = pdist(checkDistance,'euclidean');   % find distance between them
            totalDist = totalDist + distance;
        end
        
        %  what we found for the next move
        minDist;
        nextCity;
        nnVisitOrder(j,:) = nextCity;   % this starts writing on 2, which is fine because 1 gets added at the end
        
        %fprintf('Moving to city %i with a distance of %.2f \n',nextCity,minDist)
        
        % Plot line to shortest next, vector 1 is both x's, 2 is both y's
        x = [cities(currentCity,1), cities(nextCity,1)];
        y = [cities(currentCity,2), cities(nextCity,2)];
        plot(x,y,'r--','LineWidth',plotScale/8)
        
        %txt = 'Next \rightarrow  ';
        %text(cities(nextCity,1),cities(nextCity,2),txt,'HorizontalAlignment','right')
        
        % Update for next loop
        currentCity = nextCity;
        visited(nextCity) = 1;
        visitedOrder(j) = nextCity;
        minDist; % verbose
        totalDist = totalDist + minDist;
        
        % Break if we've visited everything
        if sum(visited) == maxCities, break, end
        
    end
    
    % Complete the loop
    
    a = [cities(currentCity,1), cities(currentCity,2)];  % current city coordinates
    b = [cities(startingCity,1),cities(startingCity,2)];
    
    checkDistance = [a;b]; % select two points
    distance = pdist(checkDistance,'euclidean');
    minDist;
    totalDist = totalDist + distance; % Update total distance once more
    
    x = [cities(currentCity,1), cities(startingCity,1)];
    y = [cities(currentCity,2), cities(startingCity,2)];
    plot(x,y,'r--','LineWidth',plotScale/8)
    
    if gifOutput
        drawnow
        gif
    end
    
    nn_distance = totalDist;
    
    nn_time = formatTime(toc);
    
    % add missing entries
    nnVisitOrder(1) = startingCity;        % add starting city
    nnVisitOrder(end+1) = nnVisitOrder(1); % add loopback
    
end

% Clear variables between runs
totalDist = 0;
minDist = 0;

%% Genetic Algorithm
if gena
    gaFitnessMean = 0;
    fprintf('Creating genes...\n')
    % create genes
    linearPath = [1:maxCities];
    
    for i=1:gaInitPopSize
        gaVisitOrder(i,:) = linearPath(randperm(length(linearPath)));
    end
    
    % shift matrix so starting city is correct
    for i=1:gaInitPopSize
        k = find(gaVisitOrder(i,:) == startingCity);
        gaVisitOrder(i,:) = circshift(gaVisitOrder(i,:), (maxCities+1) - k);
    end
    
    % copy first entry and place it on back
    arr = ones(1,gaInitPopSize);
    arr = arr * startingCity;
    
    gaVisitOrder;
    gaVisitOrder = flip(rot90(gaVisitOrder)); % rearrange for visitation reasons
    gaVisitOrder = [gaVisitOrder;arr];
    
    % dont add remaining city, just go back to it and let the ga sort it out?
    fprintf('Starting algorithm...\n')
    for gaGeneration=1:gaMaxGenerations
        o_ga = o_ga + 1;
        if gaGeneration==1,tic,end % start the clock
        
        % calculate lengths of each option
        for j=1:gaInitPopSize
            o_ga = o_ga + 1;
            
            for i=1:maxCities % if -1 because we loop back around instead of indexing the path back to start
                o_ga = o_ga + 1;
                
                a = [cities(gaVisitOrder(i,j),1),cities(gaVisitOrder(i,j),2)];
                b = [cities(gaVisitOrder(i+1,j),1),cities(gaVisitOrder(i+1,j),2)];
                
                checkDistance = [a;b]; % select two points
                distance = pdist(checkDistance,'euclidean');   % find distance between them
                %distance = floor(distance); % truncate
                totalDist = totalDist + distance;
                
                gaSegmentDistances(i,j) = distance;
                
            end
            
            % timing
            %         if j==bfTickSize
            %             timing = toc;
            %             bfEstimatedTime = timing*(length(bfVisitOrder)/bfTickSize) % timing*((length(bfVisitOrder)-bfTickSize)/bfTickSize) for 'time remaining as of this timing'
            %             bfTimeTicks = length(bfVisitOrder)/bfTickSize;
            %         end
            
            gaDistances(j) = totalDist; % store the total path length
            totalDist = 0;              % reset for the next run
            
            % Output running information
            %         clc
            %         fprintf('Starting BF for n=%i, O(n!)=%i \n',maxCities, bf_omax)
            %
            %         if length(bfVisitOrder) > bfTickSize % only display if enough data to estimate
            %             if bfEstimatedTime > 0
            %                 fprintf('Estimated runtime: %s\n',formatTime(bfEstimatedTime))
            %             else
            %                 fprintf('Estimated runtime: (Sampling %i more times..)\n',bfTickSize-j)
            %             end
            %         end
            %         fprintf('Current runtime  : %s\n',formatTime(toc))
            %         fprintf('Computing optimal route... %.2f%% \n', (o_bf / bf_omax) * 100)
            
        end % end of loop
        
        % normalize values for selection process (vector sum = 1)
        if verbose, gaVisitOrder, end
        if verbose, gaDistances, end
        gaFitness = gaDistances ./ norm(gaDistances,1);
        preMean = mean(gaFitness);
        if verbose, gaFitness, end
        
        
        % ** select members
        selected = zeros(1,gaInitPopSize);
        
        % use elitism to ensure high performers breed
        if gaElitism > 0
            % this automatically selects the top members and kills off the
            % bottom members
            
            gaElites = ceil(gaElitism*gaInitPopSize); % number of members who are elites
            
            % mark worst performers
            for i = 1:gaElites
                [q tempToDelete(i)] = min(gaFitness);
                gaFitness(tempToDelete(i)) = 2;  % maxing value so it doesn't get picked again
            end
            
            % kill off 'marked' worst performers
            for i = 1:length(tempToDelete)
                [q w] = max(gaFitness);
                gaFitness(w) = 0;
            end
            
            clear q;
            clear w;
            
            % select the best performers
            for i = 1:gaElites
                [q w] = max(gaFitness);
                selected(w) = 1;
                gaFitness(w) = 0;
            end
            
            clear q;
            clear w;
            
        end
        
        
        while sum(selected) < (gaInitPopSize/gaSelectionFactor) % run until it selects 1/selectionFactor of the members
            a = rand();
            for i = 1:gaInitPopSize;
                a = a - gaFitness(i);
                %fprintf('%.4f - %.4f\n',a,gaFitness(i))
                if a < 0
                    %fprintf('Selected:  %i\n',i)
                    gaFitness(i) = 0;
                    selected(i) = 1;
                    break
                end
            end
        end
        
        
        
        % get parents chromosomes
        tempMean = 0;
        k = 0;
        for i = 1:gaInitPopSize
            if gaFitness(i)
                k = k + 1;     % write to the correct indexes to prevent zero values
                gaParentChrom(:,k) = gaVisitOrder(:,i); % write parents chromosomes for use in breeding
                tempMean(k) = gaFitness(i); % capture mean for statistical reasons
            end
        end
        
        postMean = mean(tempMean(tempMean ~= 0));
        %postMean
        %t=t+1; % write correct index in gaFitnessMean;
        gaFitnessMean(gaGeneration) = postMean;
        if gaGeneration > 1
            if verbose
                fprintf('%i \t Mean %.8f -> %.8f (%.8f change)\n',gaGeneration, gaFitnessMean(gaGeneration-1), gaFitnessMean(gaGeneration), postMean/preMean)
            else
                if ~verbose, clc, end
                fprintf('Computing Genetic Algorithm... %.2f%%\n', (gaGeneration/gaMaxGenerations)*100)
            end
        end
        
        % breed new population
        %for j = 1:gaInitPopSize/4
        %gaParentChrom
        popNeeded = gaInitPopSize;
        k = 0; % indexing fix
        hit = 0;
        miss = 0;
        
        % random swap subalgorithm
        if gaRandomCrossover
            while popNeeded > 0
                
                for i = 2:maxCities   % = 2:n because the start and end cities never change
                    parenta = gaParentChrom(i,1);
                    parentb = gaParentChrom(i,2);
                    
                    if round(rand) == 1
                        newMember(i) = parenta;
                    else
                        newMember(i) = parentb;
                    end
                    
                    if verbose, fprintf('Mix %i and %i -> %i\n' ,parenta,parentb,newMember(i)), end
                end
                
                if length(unique(newMember)) == length(newMember)
                    k=k+1;
                    popNeeded = popNeeded -1;
                    newPop(k,:) = newMember;
                    hit = hit+1;
                else
                    miss = miss+1;
                    fprintf('%i miss on newmember...\n',miss)
                end
                
            end
            
            
            if verbose, newPop = unique(newPop,'rows'), end
            
        end
        
        
        %     parenta = gaParentChrom(i,1);
        %     parentb = gaParentChrom(i,2);
        %
        if gaOrderedCrossover
            gaVisitOrder = zeros(9,1); % clear visit order for new writing
            oldCrossoverPoint = 0;
            crossoverPoint = 0;
            
            [parentHeight parentLength] = size(gaParentChrom);
            
            %gaParentChrom
            
            for k=1:30 %while size(newPop,2) < gaInitPopSize ??? why 1:30? fix this ending index
                
                while oldCrossoverPoint == crossoverPoint % loop until new crossover point from last time
                    crossoverPoint = randi([2 parentHeight-2]); % ignore first and last entries since those are start/loop paths
                    if verbose, crossoverPoint, end
                end
                
                for j = 1:2:parentHeight-1
                    %clear childa, clear childb;
                    
                    childPart1 = gaParentChrom(1:crossoverPoint,j); % first half of chromosome
                    tempChild = gaParentChrom(:,j+1);               % temp store entire other parent
                    
                    % check second parent gene-by-gene, add non-duplicates in order of appearance
                    for i = 2:length(tempChild)
                        if verbose, fprintf('Checking for duplicate alele: %i\n',tempChild(i)), end
                        if ~ismember(tempChild(i),childPart1)
                            if verbose, fprintf('Adding %i to chromosome\n',tempChild(i)), end
                            childPart2(i,1) = tempChild(i);
                        end
                    end
                    
                    childPart2 = childPart2(childPart2 ~= 0);
                    
                    %childPart1
                    %childPart2
                    
                    newChild = [childPart1;childPart2;childPart1(1)];
                    
                    newPop(:,ceil(j/gaSelectionFactor)) = newChild;         % ceil to remove every other column of zeroes
                    
                    clear childPart*;          % flush old data
                    clear temp*;
                    
                end
                
                % write new visit order
                if sum(gaVisitOrder(:,1)) == 0  % if first time written
                    gaVisitOrder = newPop;
                else
                    gaVisitOrder = cat(2,gaVisitOrder,newPop);
                end
                oldCrossoverPoint = crossoverPoint; % store this to ensure a different point next time
            end
            
            %gaVisitOrder
            
        end % end of ordered crossover algorithm
        
        % *** mutate (should be a function, args of mutationType, mutationRate, initPopSize...)
        
        % mutations: random reset, single swap, selection scramble, selection inversion
        gaMutationType = 1;   % TODO put this in the header
        
        
        mutateNum = ceil(gaInitPopSize * gaMutationRate); % number of individuals to mutate
        
        % generate chromisome indexes to mutate
        for i = 1:mutateNum %TODO unique numbers each time
            mutIndex(i) = randi(gaInitPopSize);    % member to mutate
            childMut(:,i) = gaVisitOrder(:,mutIndex(i));
        end
        
        if gaMutationType == 1 % random reset
            
            childMut(end,:) = [];   % delete loopback entry so array is unique
            
            for i=1:mutateNum
                
                childMut(:,i) = randperm(maxCities);
                
                % shift matrix so starting city is correct
                k = find(childMut(:,i) == startingCity);
                childMut(:,i) = circshift(childMut(:,i), (maxCities+1) - k);
                
            end
            
            % copy first entry and place it on back (path loopback)
            arr = ones(1,mutateNum);   % array to write entire row at once
            arr = arr * startingCity;
            childMut(end+1,:) = arr;    % append new entry
            
            if verbose
                fprintf('New mutation (displayed concatenated): [');
                fprintf('%g ', childMut);
                fprintf(']\n');
            end
            
            % write mutations back into population
            for i=1:mutateNum
                gaVisitOrder(:,mutIndex(i)) = childMut(:,i);
            end
            
            
        end %end random reset algorithm
        
    end % end gaMaxGenerations
    
    ga_time = formatTime(toc);
    
    
    % plot highest fitness route, capture ga = totalDist
    for i=1:maxCities
        
        [ga_distance gaMinIndex] = max(gaDistances);
        
        a = [cities(gaVisitOrder(i,gaMinIndex),1), cities(gaVisitOrder(i,gaMinIndex),2)];
        b = [cities(gaVisitOrder(i+1,gaMinIndex),1), cities(gaVisitOrder(i+1,gaMinIndex),2)];
        
        x = [a(1), b(1)];
        y = [a(2), b(2)];
        plot(x,y,'b--','LineWidth',plotScale/6)
        
        
        %bfVisitOrder(i:4,bfShortest) gives path
        
    end
    
    
    
    % plot historical fitness
    figure('Name','Genetic Algorithm Performance','NumberTitle','off');
    
    hold on
    grid on
    gaPlotX = [1:gaGeneration]; % make a linear axis for plotting
    plot(gaPlotX,gaFitnessMean,'m.','MarkerSize',plotScale)
    
    %x = 1:10;
    %y1 = x + randn(1,10);
    %scatter(x,y1,25,'b','*')
    %   p = polyfit(gaPlotX,gaFitnessMean,1);
    %p(~ismember(p,outliers)); % purge outliers
    
    [p,s] = polyfit(gaPlotX,gaFitnessMean,1);
    
    [Yfit,delta] = polyval(p,gaPlotX,s);
    
    yfit = polyval(p,gaPlotX,s);
    %   yfit = p(1)*gaPlotX+p(2);
    %plot(gaPlotX,yfit,'b-','MarkerSize',plotMarkerSize*1.5);
    plot(gaPlotX,yfit,'-b', gaPlotX,yfit+delta,'--b', gaPlotX,yfit-delta,'--b')
    
    gaFitnessSlope = p(1);
    xlabel('Generation')
    ylabel('Fitness')
    legend('Avg Generational Fitness',['Slope = ',num2str(gaFitnessSlope)],'Delta')
    title('Genetic Algorithm Performance')
    %title(['Slope is ',num2str(gaFitnessSlope)])
    
end % end of ga

%% ---- Subplot Figure
figure('Name','Split Routes','NumberTitle','off');

axis tight manual


subplot(2,2,1)
grid on
hold on
xlim([minLoc maxLoc])
ylim([minLoc maxLoc])
if ~bf, title('BF (not run)'), else, title('BF'), end

% BF
if bf
    for i=1:maxCities
        
        if i == startingCity
            plot(cities(i,1),cities(i,2),'bo','MarkerSize',plotScale/2)
            
        else
            plot(cities(i,1),cities(i,2),'k^','MarkerSize',plotScale/2)
        end
    end
    for i=1:maxCities
        a = [cities(bfVisitOrder(i,bfMinIndex),1), cities(bfVisitOrder(i,bfMinIndex),2)];
        b = [cities(bfVisitOrder(i+1,bfMinIndex),1), cities(bfVisitOrder(i+1,bfMinIndex),2)];
        x = [a(1), b(1)];
        y = [a(2), b(2)];
        plot(x,y,'g','LineWidth',plotScale/8)
    end
end

% GA
subplot(2,2,4)
grid on
hold on
xlim([minLoc maxLoc])
ylim([minLoc maxLoc])
if ~gena, title('GA (not run)'), else, title('GA'), end
if gena
    for i=1:maxCities
        
        if i == startingCity
            plot(cities(i,1),cities(i,2),'bo','MarkerSize',plotScale/2)
            
        else
            plot(cities(i,1),cities(i,2),'k^','MarkerSize',plotScale/2)
        end
    end
    for i=1:maxCities
        a = [cities(gaVisitOrder(i,gaMinIndex),1), cities(gaVisitOrder(i,gaMinIndex),2)];
        b = [cities(gaVisitOrder(i+1,gaMinIndex),1), cities(gaVisitOrder(i+1,gaMinIndex),2)];
        x = [a(1), b(1)];
        y = [a(2), b(2)];
        plot(x,y,'b','LineWidth',plotScale/8)
    end
    
end

subplot(2,2,3)
grid on
hold on
xlim([minLoc maxLoc])
ylim([minLoc maxLoc])
if ~nn, title('NN (not run)'), else, title('NN'), end

% NN
if nn
    for i=1:maxCities
        
        if i == startingCity
            plot(cities(i,1),cities(i,2),'bo','MarkerSize',plotScale/2)
            
        else
            plot(cities(i,1),cities(i,2),'k^','MarkerSize',plotScale/2)
        end
    end
    for i=1:maxCities
        a = [cities(nnVisitOrder(i),1), cities(nnVisitOrder(i),2)];
        b = [cities(nnVisitOrder(i+1),1), cities(nnVisitOrder(i+1),2)];
        x = [a(1), b(1)];
        y = [a(2), b(2)];
        plot(x,y,'r','LineWidth',plotScale/8)
        
    end
end

%% ---- Results and Analysis ----------------------------------------------
if outputResults
    fprintf('\nTravelling done!\n')
    fprintf('------- Results -------\n')
    
    fprintf(1, 'Alg. |\tBF\t\tNN\t\tGA\n')
    fprintf(1, 'O(n) |\t%i\t\t%i\t\t%i\n', o_bf, o_nn, o_ga)
    fprintf(1, 'Dist.|\t%.2f\t\t%.2f\t\t%.2f\n', bf_distance, nn_distance, ga_distance')
    fprintf(1, 'Time |\t%s\t\t%s\t\t%s\n', bf_time, nn_time, ga_time)
    fprintf('\n')
    fprintf('NN algorithm path is %.2fx (%.2f%%) longer and %.2fx computationally faster.\n',nn_distance/bf_distance, (abs(1-(nn_distance/bf_distance)))*100, o_bf/o_nn)
end

%% ----- Functions --------------------------------------------------------
function t=formatTime(secs);
% Input seconds, output formatted '_h_m_s'

if secs == 0
    t=sprintf('(no time available)');
    return
elseif secs < 1
    t=sprintf('<1s');
    return
else
    hours = 0;
    minutes = 0;
    seconds = 0;
    minutes = floor(secs / 60);
    seconds = rem(secs, 60);
    if minutes > 60
        hours = floor(minutes / 60);
        minutes = minutes - (hours*60);
    end
    t=sprintf('%ih%im%.0fs',hours,minutes,seconds);
    return
end
end