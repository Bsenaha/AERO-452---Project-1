% Propogation EOMs for Circular Orbit
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