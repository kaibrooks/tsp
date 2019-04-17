% Calculates the Mandelbrot set in a small region around z= -0.748 + i 0.123
close all;
clear all;
clc;

maxIterations = 500; % If still within less than 2 from the origin
gridSize = 1000; % We are going to sample 1K by 1K number of points around -0.748 + i 0.123
xlim = [-0.748766713922161, -0.748766707771757]; % The limits of the region we are exploring
ylim = [ 0.123640844894862, 0.123640851045266];

% Setup
t = tic();
x = linspace( xlim(1), xlim(2), gridSize ); % Populating all the x's
y = linspace( ylim(1), ylim(2), gridSize ); % and y's
[ xGrid, yGrid ] = meshgrid( x, y ); % magical incantation to calculate things nicely
z0 = xGrid + 1i*yGrid; % this our complex number. So we have 1M numbers here
count = ones( size(z0) ); % this is how many steps it took while still < 2.

% Calculate the set
z = z0;
for n = 0:maxIterations
    z = z.*z + z0;
    inside = abs( z ) <= 2;
    count = count + inside;
end
count = log( count ); % take the log so we get a pleasing picture, for fun

% Show the set

cpuTime = toc( t )
a = imagesc(x,y,count);
a
axis image
axis off
colormap( [jet();flipud( jet() );0 0 0] );
saveas(a, 'images\mandelbrot.png','png');
