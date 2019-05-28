% TSP GA
% Kai brooks
% Jun 2019
% Description
%
% Solves the travelling salesman problem using a genetic algorithm

clc
close all
clear all
format

rng('shuffle')

maxCities = 10;  % number of cities to visit
minLoc = 1;  % minimum coordinate to generate for city locations
maxLoc = 100;  % maximum coordinate to generate for city locations
verbose = 1;    % outputs things, maybe
attempts = 100; % number of attempts to bruteforce the solution before giving up
plotMarkerSize = 10;   % size of markers on map
currentCity = 1; % start at the first city, n=1
totalDist = 0;   % total distance travelled
o_bf = 0;        % big o for bruteforce method
maxCpuTime = 100; % max loops various functions will use before giving up and moving on

% Generate points
cities = randi([minLoc, maxLoc],2,maxCities); % generate crooked matrix
cities = rot90(cities);  % rotate to form cities(x1,y1) for each point
cities = unique(cities,'rows'); % remove duplicate entries

if (length(cities) ~= maxCities)
    fprintf('*** Generated duplicate city coordinates, pruning %i entries.\n*** New maxCities = %i \n', maxCities - length(cities), length(cities))
end

maxCities = length(cities);  % shorten everything else if we don't have enough cities




visited = zeros([maxCities],1); % boolean to mark each visited city
visited(currentCity) = 1;

visitedOrder = zeros([maxCities],1); % vector to store the order which we visited each city
visitedOrder(currentCity) = 1;

% Map cities to give the user something to look at while we compute
figure(1)
hold on
grid on

xlim([minLoc maxLoc])
ylim([minLoc maxLoc])

% Attempt bruteforce distance
% Find distance between all cities from current location


for i=1:maxCities
    if i == 1
        plot(cities(i,1),cities(i,2),'bo','MarkerSize',plotMarkerSize)
    else
        plot(cities(i,1),cities(i,2),'kd','MarkerSize',plotMarkerSize)
    end
    
end

txt = '    \leftarrow Start';
text(cities(1,1),cities(1,2),txt)


for j = 2:maxCities
    
    ccLoc = [cities(currentCity,1), cities(currentCity,2)]; % coords of current city
    
    minDist = maxLoc^2;   % starting distance, make maximum possible
    
    for i = 1:maxCities
        o_bf = o_bf + 1;
        
        if visited(i) == 1, continue, end % skip cities we've visited
        
        a = ccLoc;  % current city coordinates
        b = [cities(i,1),cities(i,2)];
        
        checkDistance = [a;b]; % select two points
        
        distance = pdist(checkDistance,'euclidean');    % find distance between them
        
        if distance < minDist
            minDist = distance;
            nextCity = i;
            nextLoc = [cities(i,1),cities(i,2)];
        end
    end
    
    %  what we found for the next move
    minDist;
    nextCity;
    
    fprintf('Moving to city %i with a distance of %.2f \n',nextCity,minDist)
    
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
    totalDist = totalDist + minDist;
    
end

fprintf('-- Travelling done! -- \n')

visitedOrder
totalDist
o_bf

