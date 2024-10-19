% Football Maneuver
function [t, deltav_LVLH, out] = Football(downrange, P)
% INPUT:
% downrange = chaser distance from target (positive downrange = in front)
% [km]
% P = target/chaser orbital period [s]

% OUTPUT:
% t = time [s]
% deltav_x = delta v required to get onto football maneuver (must be
% doubled for calculating getting off) [km/s]
% out = state outputs from maneuver (columns 1-3 position [km], columns 4-6
% relative velocity [km/s])

% define football parameters
n = 2 * pi / P; % calculate mean motion
deltav_x = downrange * n / 2; % calculate necessary delta v

% define initial state
R_0 = [0; downrange; 0]; % Initial LVLH coords [km]
V_0 = [deltav_x; 0; 0];  % Initial LVLH rel. velocity [km/s]
deltav_LVLH = V_0; % applied delta V in LVLh [km/s]
state0 = [R_0; V_0];     % downrange in y, delta v in x

% call circular propogation
options = odeset('RelTol',1e-8,'AbsTol',1e-8);
[t, out] = ode45(@circEOM, [0 P], state0, options, n);
