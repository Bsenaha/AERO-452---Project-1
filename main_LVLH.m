%% ALL LVLH Calculations

clc; clear; close all
mu_Earth = 398600; %[km3/s2]

%% Football

% define football parameters
downrange = 40; % position in front or behind [km]
n = 2*pi/OPS_orbit.P; % calculate mean motion
[deltav_x] = Football(downrange, n);

options = odeset('RelTol',1e-8,'AbsTol',1e-8);
state0 = [0; downrange; 0; deltav_x; 0; 0];
[t, out] = ode45(@circEOM, [0 OPS_orbit.P], state0, options, n);

figure()
dv = vecnorm(out(:, 4:6)', 3);
plot(t, dv)
figure()
plot(out(:,2), out(:,1))

function [out] = circEOM(t, state, n)
x = state(1);
y = state(2);
z = state(3);

dx = state(4);
dy = state(5);
dz = state(6);

ddx = 3*n^2*x+2*n*dy;
ddy = -2*n*dx;
ddz = -n^2*dz;

out = [dx;dy;dz;ddx;ddy;ddz];
end