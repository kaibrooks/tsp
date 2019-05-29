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

maxCities = 8;  % number of cities to visit
minLoc = 1;  % minimum coordinate to generate for city locations
maxLoc = 100;  % maximum coordinate to generate for city locations
verbose = 1;    % outputs things, maybe
attempts = 100; % number of attempts to bruteforce the solution before giving up
plotMarkerSize = 10;   % size of markers on map
totalDist = 0;   % total distance travelled
o_nn = 0;        % big o for nearest neighbor method
o_bf = 0;        % big o for bruteforce method
maxCpuTime = 100; % max loops various functions will use before giving up and moving on

gifOutput = 1;  % outputs a gif or not
gifWritten = 0;

nn = 1;         % nearest-neighbor algorithm
bf = 1;         % bruteforce algorithm


% Generate points
cities = randi([minLoc, maxLoc],2,maxCities); % generate crooked matrix
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
arr = [1:maxCities];
bfVisitOrder = perms(arr);
fprintf('Bruteforce computation will take %i iterations\n',length(bfVisitOrder))
bfVisitOrder = rot90(bfVisitOrder); % flip it to make indexing easier


% Map cities to give the user something to look at while we compute
f = figure('units','normalized','outerposition',[0 0 1 1])
%figure
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'nn.gif';
hold on
grid on

xlim([minLoc maxLoc])
ylim([minLoc maxLoc])

% Attempt bruteforce distance
% Find distance between all cities from current location

% Plot cities
for i=1:maxCities
    if i == startingCity
        plot(cities(i,1),cities(i,2),'bo','MarkerSize',plotMarkerSize)
    else
        plot(cities(i,1),cities(i,2),'k^','MarkerSize',plotMarkerSize)
    end
end
txt = '    \leftarrow Start';
text(cities(startingCity,1),cities(startingCity,2),txt)

% Bruteforce Algorithm
%bfVisitOrder
%cities
if bf == 1
    minDist = maxLoc^2;  % Starting minimum distance
    % while sum(visited) < maxCities
    
    for j=1:length(bfVisitOrder)
        for i=1:maxCities
            o_bf = o_bf + 1;
            
            a = [cities(bfVisitOrder(i,j),1),cities(bfVisitOrder(i),2)];
            b = [cities(bfVisitOrder(i+1),1),cities(bfVisitOrder(i+1),2)];
            
            checkDistance = [a;b]; % select two points
            
            distance = pdist(checkDistance,'euclidean');   % find distance between them
            totalDist = totalDist + distance;
        end
        bfDist(j) = totalDist;
        
        if totalDist < minDist
            minDist = totalDist;
            bfShortest = j;
        end
        
        totalDist = 0;
    end
    
    %bfDist
    bfShortest
    bfDist(bfShortest)
    
    % Plot it
    for i=1:maxCities-1
        a = [cities(bfVisitOrder(i,bfShortest),1), cities(bfVisitOrder(i,bfShortest),2)]
        b = [cities(bfVisitOrder(i+1,bfShortest),1), cities(bfVisitOrder(i+1,bfShortest),2)]
        x = [a(1), b(1)];
        y = [a(2), b(2)];
        plot(x,y,'b--','LineWidth',plotMarkerSize/8)
   
    %bfVisitOrder(i:4,bfShortest) gives path
   
    end
    % Close the end to form the loop
    a = [cities(bfVisitOrder(maxCities,bfShortest),1), cities(bfVisitOrder(maxCities,bfShortest),2)]
    b = [cities(bfVisitOrder(1,bfShortest),1), cities(bfVisitOrder(1,bfShortest),2)]
    x = [a(1), b(1)];
    y = [a(2), b(2)];
    plot(x,y,'b--','LineWidth',plotMarkerSize/8)
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
        totalDist = totalDist + minDist;
        
        % Break if we've visited everything
        if sum(visited) == maxCities, break, end
        
    end
    
    % Complete the loop
    a = ccLoc;  % current city coordinates
    b = [cities(startingCity,1),cities(startingCity,2)];
    
    checkDistance = [a;b]; % select two points
    distance = pdist(checkDistance,'euclidean');
    totalDist = totalDist + distance; % Update total distance once more
    
    x = [cities(currentCity,1), cities(startingCity,1)];
    y = [cities(currentCity,2), cities(startingCity,2)];
    plot(x,y,'r--','LineWidth',plotMarkerSize/8)
    
    drawnow
    gif
    
end




fprintf('-- Travelling done! -- \n')

%visitedOrder
%totalDist
%o_nn
