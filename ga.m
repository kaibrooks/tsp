% TSP GA
% Kai brooks
% 8 Apr 2019
% Description
%
% Solves the travelling salesman problem using a genetic algorithm

clc
close all
clear all
format

rng('shuffle')

maxCities = 4;  % number of cities to visit
minLoc = 1;  % minimum coordinate to generate for city locations
maxLoc = 100;  % maximum coordinate to generate for city locations
verbose = 1;    % outputs things, maybe
attempts = 100; % number of attempts to bruteforce the solution before giving up
plotMarkerSize = 10;   % size of markers on map
currentCity = 1; % start at the first city, n=1

% Generate points
cities = randi([minLoc, maxLoc],2,maxCities);
cities = rot90(cities)  % rotate to form cities(x1,y1) for each point

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


ccLoc = [cities(currentCity,1), cities(currentCity,2)]; % coords of current city, probably not needed since we can just grab the array index instead

plot(cities(1,1),cities(1,2),'bo','MarkerSize',plotMarkerSize)
txt = '    1';
text(cities(1,1),cities(1,2),txt)

plot(cities(2,1),cities(2,2),'k^','MarkerSize',plotMarkerSize)
txt = '    2';
text(cities(2,1),cities(2,2),txt)

plot(cities(3,1),cities(3,2),'k^','MarkerSize',plotMarkerSize)
txt = '    3';
text(cities(3,1),cities(3,2),txt)

plot(cities(4,1),cities(4,2),'k^','MarkerSize',plotMarkerSize)
txt = '    4';
text(cities(4,1),cities(4,2),txt)


minDist = maxLoc^2;   % starting distance, make maximum possible
for n = 1:maxCities-1
    a = ccLoc;  % current city coordinates
    b = [cities(n+1,1),cities(n+1,2)];
    
    checkDistance = [a;b]; % select two points
    
    distance = pdist(checkDistance,'euclidean');    % find distance between them
    
    if distance < minDist
        minDist = distance;
        nextCity = n+1;
        nextLoc = [cities(n+1,1),cities(n+1,2)];
    end
    
    %plot(a,b)
    
end

% Display what we found for the next move
visited(nextCity) = 1;
visitedOrder(2) = nextCity;

minDist;
nextCity;

fprintf('Moving to city %i with a distance of %.2f \n',nextCity,minDist)



% Plot line to shortest next, vector 1 is both x's, 2 is both y's
x = [cities(currentCity,1), cities(nextCity,1)];
y = [cities(currentCity,2), cities(nextCity,2)];
plot(x,y,'r--','LineWidth',plotMarkerSize/8)

txt = 'Next \rightarrow  ';
text(cities(nextCity,1),cities(nextCity,2),txt,'HorizontalAlignment','right')
