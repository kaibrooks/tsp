% TSP GA
% Kai Brooks
% Jun 2019
% Description
%
% Solves the travelling salesman problem
% Program first solves using the 'bruteforce' method and plots it in blue
% Program then uses nn algorithm and solves it in red
%

% Init
clc
close all
clear all
format

rng('shuffle')

% --- Main options --------------------------------------------------------

maxCities = 9;          % (default 9) number of cities to visit, this is the 'n'
                        % decrease this if it hurts the hardware
gifOutput = 1;          % enables gif output and generation, slows rendering                        
filename = 'nn.gif';
% Algorithm enables
bf = 1;                 % bruteforce algorithm
nn = 1;                 % nearest-neighbor algorithm
    
% --- Advanced options and generator settings -----------------------------

bfTickSize = 10000;     % (default 10000) tick size for timing BF algorithm. Higher numbers = more accuracy, slower to display estimate
minLoc = 1;             % (default 1) minimum coordinate to generate for city locations
maxLoc = 100;           % (default 100) maximum coordinate to generate for city locations
plotMarkerSize = 15;    % (default 10) size of markers on map

verbose = 1;            % outputs things, maybe
attempts = 100;         % number of attempts to bruteforce the solution before giving up

% --- Declare other variables (do not modify) -----------------------------

totalDist = 0;          % total distance travelled
o_nn = 0;               % big o for nearest neighbor method
o_bf = 0;               % big o for bruteforce method
maxCpuTime = 100;       % max loops various functions will use before giving up and moving on
gifWritten = 0;         % one-time check for gif creation


% --- Program start -------------------------------------------------------

% Generate points
cities = randi([minLoc, maxLoc],2,maxCities); % generate matrix
cities = rot90(cities);  % rotate to form cities(x1,y1) for each point
cities = unique(cities,'rows'); % remove duplicate entries

if (length(cities) ~= maxCities)
    fprintf('*** Generated duplicate city coordinates, pruning %i entries.\n*** New maxCities = %i \n', maxCities - length(cities), length(cities))
end

maxCities = length(cities);  % shorten everything else if we don't have enough cities


startingCity = randi(maxCities);
currentCity = startingCity;

visited = zeros([maxCities],1); % boolean to mark each visited city
visited(currentCity) = 1;

visitedOrder = zeros([maxCities],1); % vector to store the order which we visited each city
visitedOrder(currentCity) = 1;

% Create bruteforce path matrix: o(n!)
arr = [2:maxCities];
bfVisitOrder = perms(arr);
bfVisitOrder = rot90(bfVisitOrder); % flip it to make indexing easier

arr = ones(1,length(bfVisitOrder)); % create array of 1's
bfVisitOrder = [arr;bfVisitOrder];  % append to the beginning

% Add original city back onto end to complete the loop
for i = 1:length(bfVisitOrder)
    bfVisitOrder(maxCities+1,i) = bfVisitOrder(1,i);
end

[x,y] = size(bfVisitOrder);  % get total size of matrix
bf_omax = x*y;


% Create figure
f = figure('units','normalized','outerposition',[0 0 1 1]);
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
    text(cities(i,1),cities(i,2),sprintf('   %i', i))
    
end

txt = '    \leftarrow Start';
text(cities(startingCity,1),cities(startingCity,2),txt)

% Algorithms
% Bruteforce Algorithm
%bfVisitOrder
%cities

bfEstimatedTime = 0;
if bf == 1
    minDist = maxLoc^2;  % Starting minimum distance
    % while sum(visited) < maxCities
    
    for j=1:length(bfVisitOrder)
        o_bf = o_bf + 1;
        
        if j==1,tic,end
        
        for i=1:maxCities %+1 to account for return to start
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
            bfEstimatedTime = timing*((length(bfVisitOrder)-bfTickSize)/bfTickSize) % timing*((length(bfVisitOrder)-bfTickSize)/bfTickSize) for 'time remaining as of this timing'
            bfTimeTicks = length(bfVisitOrder)/bfTickSize;
        end
        
        bfDistances(j) = totalDist; % store the total path length
        totalDist = 0;              % reset for the next run
        
        % Output running information
        clc
        fprintf('Starting BF for n=%i, O(n!)=%i \n',maxCities, bf_omax)
        if length(bfVisitOrder) > bfTickSize % only display if enough data to estimate
            if bfEstimatedTime > 0
                fprintf('Estimated runtime: %.2f seconds\n',bfEstimatedTime)
            else
                fprintf('Estimated runtime: (Sampling %i more times..)\n',bfTickSize-j)
            end
        end
        fprintf('Computing optimal route... %.2f%% \n', (o_bf / bf_omax) * 100)
        
    end
    
    % Find min value
    [bfMinDist,bfMinIndex] = min(bfDistances);
    %bruteforce_path_taken = bfVisitOrder(:,bfMinIndex)
    
    %min(bfDist)
    %bfDist(j)
    
    %bfDist
    %     bfMinIndex
    %     bfDistances(bfMinIndex)
    
    % Plot it
    for i=1:maxCities
        
        a = [cities(bfVisitOrder(i,bfMinIndex),1), cities(bfVisitOrder(i,bfMinIndex),2)];
        b = [cities(bfVisitOrder(i+1,bfMinIndex),1), cities(bfVisitOrder(i+1,bfMinIndex),2)];
        
        x = [a(1), b(1)];
        y = [a(2), b(2)];
        plot(x,y,'b--','LineWidth',plotMarkerSize/8)
        
        
        %bfVisitOrder(i:4,bfShortest) gives path
        
    end
    
    %fprintf('BF method complete in %.2f seconds\n', toc)
end

% Reset variables
totalDist = 0;
minDist = 0;

% Nearest Neighbor Algorithm
if nn == 1
    for j = 2:maxCities
        
        o_nn = o_nn + 1;
        
        ccLoc = [cities(currentCity,1), cities(currentCity,2)]; % coords of current city
        
        minDist = maxLoc^2;   % starting distance, make maximum possible
        
        for i = 1:maxCities
            o_nn = o_nn + 1;
            
            if visited(i) == 1, continue, end % skip cities we've visited
            
            a = ccLoc;  % current city coordinates
            b = [cities(i,1),cities(i,2)];
            
            checkDistance = [a;b]; % select two points
            
            distance = pdist(checkDistance,'euclidean');    % find distance between them
            
            % Draw decision lines
            if gifOutput == 1
                % Draw 'decision' line
                x = [cities(currentCity,1), cities(i,1)];
                y = [cities(currentCity,2), cities(i,2)];
                plot(x,y,'g:','LineWidth',plotMarkerSize/8)
                
                
                drawnow
                % Capture the plot as an image
                title("" + o_nn)
                if  gifWritten == 0
                    gifWritten = 1;
                    gif('nn.gif','DelayTime',0.01,'LoopCount',1,'frame',gcf)
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
end


bruteforce_distance = bfDistances(bfMinIndex);
bruteforce_minimum_vec = min(bfDistances);

nn_distance = totalDist;


fprintf('Travelling done!\n')
fprintf('------- Results -------\n')

fprintf(1, 'Alg. |\tBF\tNN\n')               
fprintf(1, 'O(n) |\t%i\t%i\n', o_bf, o_nn)
fprintf(1, 'Dist.|\t%.2f\t%.2f\n', bruteforce_distance, nn_distance')
fprintf('\n')
fprintf('NN algorithm path is %.2fx (%.2f%%) longer and %.2fx computationally faster.\n',nn_distance/bruteforce_distance, (abs(1-(nn_distance/bruteforce_distance)))*100, o_bf/o_nn)

