% TSP
% Kai Brooks
% Jun 2019
%
% Solves the travelling salesman problem
% Program first solves using the np method and plots it in blue
% Program then uses nn algorithm and solves it in red
%

% Init
clc
close all
clear all
format

% --- Main options --------------------------------------------------------

maxCities = 10;          % (default 9) number of cities to visit, this is the 'n'
                        % decrease this if it hurts the hardware
gifOutput = 1;          % enables gif output and generation, slows rendering
filename = 'tsp.gif';    % output filename for the gif

twelveCitySeed = 0;     % use pre-computed 12-city seed and skips the bf calculation
                        % if 0, shuffles seed instead and runs bf normally

% TCS route: 1, 2, 4, 7, 9, 10, 12, 11, 8, 6, 5, 3, 1
% TCS index: 35462161
% TCS dist: 300.25
% TCS NN algorithm path is 1.04x (3.84%) longer and 3628800.00x computationally faster.

% Algorithm enables (with all disabled, just generates the map)
bf = 0;                   % bruteforce algorithm
nn = 0;                   % nearest-neighbor algorithm
gena = 1;                 % genetic algorithm

% --- Advanced options and generator settings -----------------------------

outputResults = 0;      % (default 1) shows analysis at completion

bfTickSize = 10000;     % (default 10000) tick size for timing BF algorithm. Higher numbers = more accuracy, slower to display estimate
gaInitPopSize = 5;      % (default ???) population for genetic algorithm 

minLoc = 1;             % (default 1) minimum coordinate to generate for city locations
maxLoc = 100;           % (default 100) maximum coordinate to generate for city locations
plotMarkerSize = 10;    % (default 10) size of markers on map
showLabels = 1;         % (default 1) display city numbers on plot

verbose = 1;            % outputs things, maybe
attempts = 100;         % number of attempts to bruteforce the solution before giving up
maxCpuTime = 100;       % max loops various functions will use before giving up and moving on

% --- Zero other variables (do not modify) --------------------------------

totalDist = 0;          % total distance travelled
gifWritten = 0;         % one-time check for gif creation

o_nn = 0;               % big o for nearest neighbor method
o_bf = 0;               % big o for bruteforce method
o_ga = 0;
nn_distance = 0;        % total minimum distance
bf_distance = 0;
ga_distance = 0;
bf_time = 0;            % time to run algorithm
nn_time = 0;
ga_time = 0;

nnSecs = 0;
bruteforce_minimum_vec = 0;

% --- Program start -------------------------------------------------------

% Override the rng if using the precomputed seed
if twelveCitySeed
    rng('default')
    maxCities = 12;
else
    rng('shuffle')
end

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
%f = figure('units','normalized','outerposition',[0 0 1 1]);
axis tight manual % this ensures that getframe() returns a consistent size

hold on
grid on

xlim([minLoc maxLoc])
ylim([minLoc maxLoc])

txt = '    \leftarrow Start';

% Plot cities
for i=1:maxCities
    
    if i == startingCity
        plot(cities(i,1),cities(i,2),'bo','MarkerSize',plotMarkerSize)
        
    else
        plot(cities(i,1),cities(i,2),'k^','MarkerSize',plotMarkerSize)
    end
    if showLabels, text(cities(i,1),cities(i,2),sprintf('   %i', i)), end
    
end

txt = '    \leftarrow Start';
text(cities(startingCity,1),cities(startingCity,2),txt)

% --- Algorithms ----------------------------------------------------------
% Bruteforce algorithm (bf)
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
        plot(x,y,'b--','LineWidth',plotMarkerSize/8)
        
        
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

% Nearest Neighbor Algorithm
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
                
                h = plot(x,y,'g:','LineWidth',plotMarkerSize/8)
                uistack(h,'bottom');
                
                drawnow
                % Capture the plot as an image
                title("" + o_nn)
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
        
        %fprintf('Moving to city %i with a distance of %.2f \n',nextCity,minDist)
        
        % Plot line to shortest next, vector 1 is both x's, 2 is both y's
        x = [cities(currentCity,1), cities(nextCity,1)];
        y = [cities(currentCity,2), cities(nextCity,2)];
        plot(x,y,'r--','LineWidth',plotMarkerSize/8)
        
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
    plot(x,y,'r--','LineWidth',plotMarkerSize/8)
    
    if gifOutput
        drawnow
        gif
    end
    
    nn_distance = totalDist;
    
    nn_time = formatTime(toc);
end

% Clear variables between runs
totalDist = 0;
minDist = 0;

% genetic algorithm
if gena
% create genes
linearPath = [1:maxCities];

for i=1:gaInitPopSize
    dnade(i,:) = linearPath(randperm(length(linearPath)));
end

% shift matrix so starting city is correct
for i=1:gaInitPopSize
    k = find(dnade(i,:) == startingCity);
    dnade(i,:) = circshift(dnade(i,:), (maxCities+1) - k);
end

dnade

% dont add remaining city, just go back to it and let the ga sort it out?




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
% uniqueEntries = 0;
% for i = 1:initPopSize
%     a = dnade(i:i,:);
%     if length(a) == length(unique(a))
%         %fprintf('%i: unique\n',i)
%         uniqueEntries = uniqueEntries + 1;
%     else
%         %fprintf('%i: not unique\n',i)
%     end
% end
% 
% uniqueRatio = uniqueEntries / initPopSize;
% 
% fprintf('%i valid genotypes: %.2f%%',uniqueEntries, uniqueRatio*100)


end


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