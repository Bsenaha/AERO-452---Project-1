% two body propogation function to save space
function [t, Rf, Vf, R, V] = propogate(dt, y0, options, mu_Earth)
% outputs time and associated states of R and V based on inputs
% save time and space assigning outputs

% INPUT:
% dt = propogation duration
% y0 = initial states [Rx; Ry; Rz; Vx; Vy; Vz]
% mu_Earth = mu of Earth

% OUTPUT:
% t = time [s]
% Rf = velocity after propogation
% Vf = velocity after propogation
% R = all positions during propogation
% V = all velocities during propogation

% call ode based on given parameters
[t, state] = ode45(@tbsMotion, [0 dt], y0, options, mu_Earth);

Rf = state(end, 1:3)';
Vf = state(end, 4:6)';

R = state(:, 1:3);
V = state(:, 4:6);
