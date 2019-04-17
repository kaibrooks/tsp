% Title
% Kai brooks
% 16 Apr 2019
% Description
%
% The following recursion relation, the logistic map, has many interesting
% aspects we will explore. x_n+1 = rx_n(1-x_n)
% [An aside: Why is this interesting? In r/K selection theory, selective
% pressures are hypothesized to drive evolution in one of two generalized
% directions: r- or k-selection. These terms, r and K, are drawn from
% standard ecological algebra as illustrated in the simplified Verhulst
% model of population dynamics: dN/dt = rN(1-(N/K)) where K is the carrying
% capacity and r defines the growth rate
% Start with x_1 = rand(). Calculate the x_n for n = 1...100. Plot the
% sequence x_n, for n=50...100, for r = 2.99, 3.05, 3.54, 3.6
% If you plot a sequence of x_n for n=50...100, as a function of r, after
% the initial transients have died down, i.e., one r value (the 'x-axis'
% of the plot) and a bunch of x values (the 'y-axis' of the plot), you will
% get the figure [figure]

clc
close all
clear all
format
rng(3416)   % maintain seed for testing

r(1)=2.99;
r(2)=3.05;
r(3)=3.54;
r(4)=3.6;

% preallocate memory
x = zeros(100);
y = zeros(100);
z = zeros(100);
w = zeros(100);


% Generate x_1

x = rand()
y = x;
z = x;
w = x;

% Calculate x_n for n = 1:100
% x_n+1 = rx_n(1-x_n)


for n=1:100
    x(n+1) = r(1)*x(n)*(1-(x(n)));
end

for n=1:100
    y(n+1) = r(2)*x(n)*(1-(x(n)));
end

for n=1:100
    z(n+1) = r(3)*x(n)*(1-(x(n)));
end

for n=1:100
    w(n+1) = r(4)*x(n)*(1-(x(n)));
end

hold on

figure(1)

plot (x)
plot (y)
plot (z)
plot (w)

legend
axis tight

%x(:) % output entire vector

% Plot x_n for n=50:100 as a function of r

%plot(x,r)

% Automated feedback script
% test='filename.m';
% str = '&body= Hi Kai,  %0D%0A  %0D%0A    Your program works well, except for: ';
% email=strcat('kbrooks@pdx.edu?subject=[PH322 feedback] %20', test, str );
% url = ['mailto:',email];
% web(url)