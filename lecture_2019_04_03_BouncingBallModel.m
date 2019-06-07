% Kai Brooks
% 2019-04-03
% Model a ball falling from distance h and bouncing, position vs time

clc
close all
clear all

% falling ball demo script -- falling_ball_CR.m
% computes solution of falling object under force of gravity with a bounce
% h(t) = h(0) + v0 * t - 1/2 g t^2  

close all;clear;
%  t spans times from 0 to 10 seconds 
% what are the appropriate time steps?  Max speed is 1/2 g t^2 = 5-->
% t=sqrt (10 / g) and speed at that time is g*t= 10 m/s; desired accuracy
% 1cm --> delta t =  0.01 m /(g*t)= 0.001 sec
t = 0 : 0.001 : 10;
g = 9.8;
h0 = 5; % initial height (m)
v0 = 0; % initial speed (m/s)
t0 = 0;
for n = 1 : length( t )
    h( n ) = h0 + v0 * (t(n) - t0)- .5 *g * ( t(n) - t0 )^2;
    if h(n) <0
        h0 = 0;  % New height
        v0 = -0.7* (v0 - g* (t(n) - t0) );  % New speed, assume the bounce is at 70% of initial speed
        t0 = t(n) ; % new time t0
    end
end

plot( t , h );
xlabel( 'time (s) ' );
ylim( [ 0 5]);
ylabel( 'position (m)' );
title( 'Falling Ball' );
grid on