% Vbar Approach 
function [t, out] = Vbar(downrange, vc, P, dt)
% INPUT:
% downrange = chaser distance from target (positive downrange = in front)
% [km]
% vc = approach velocity %[km/s]
% P = period of orbit [s]
% dt = approach duration [s]

% OUTPUT:
% t = time [s]
% out = 

n = 2 * pi / P; % calculate mean motion

R_0 = [0; downrange; 0]; % Initial LVLH coords [km]
V_0 = [0; vc; 0];        % Initial LVLH rel. velocity [km/s]
state0 = [R_0; V_0];     % initial state in LVLH

options = odeset('RelTol',1e-8,'AbsTol',1e-8);
[t,out] = ode45(@VbarProp, [0, dt], state0, options, n, vc);
end

function [out] = VbarProp(t,states,n,vc)
x = states(1);
y = states(2);
z = states(3);

dx = states(4);
dy = states(5);
dz = states(6);

ddx = 3*n^2*x+2*n*dy-2*n*vc;
ddy = -2*n*dx;
ddz = -n^2*dz;

out = [dx;dy;dz;ddx;ddy;ddz];
end