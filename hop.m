% Hop Function
function [t, deltav_LVLH, h, out] = hop(downrange, y, P)
% INPUT:
% downrange = chaser distance from target (positive downrange = in front)
% [km]
% y = desired CHANGE in distance [km]
% P = period of orbit [s]

% OUTPUT:
% t = time [s]
% deltav_y = delta v required to get onto hop maneuver (must be
% doubled for calculating getting off) [km/s]
% h = height of hop [km]

% find required delta v and associated h
n = 2 * pi / P; % calculate mean motion
deltav_y = - y * n / 6 / pi; % calculate delta v
h = 4 * deltav_y / n; % calculate height of hop

% define initial state
R_0 = [0; downrange; 0]; % Initial LVLH coords [km]
V_0 = [0; deltav_y; 0];  % Initial LVLH rel. velocity [km/s]
deltav_LVLH = V_0; % applied delta V in LVLh [km/s]

state0 = [R_0; V_0]; % initial state in LVLH

options = odeset('RelTol',1e-8,'AbsTol',1e-8);
[t, out] = ode45(@circEOM, [0 P], state0, options, n) ;
