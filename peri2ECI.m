function C = peri2ECI(omega,inc,RAAN)
% takes in argument of periapse, inclination, and RAAN and gives
% rotation matrix to go from perifocal coordinates to ECI coordinates
    
% INPUT:
% omega = argument of periapse[rad]
% inclination = orbit inclination [rad]
% RAAN = right ascension of ascending node [rad]

% OUTPUT:
% C = rotation matrix from perifocal to ECI

C1 = [cos(omega) sin(omega) 0;-sin(omega) cos(omega) 0;0 0 1];
C2 = [1 0 0;0 cos(inc) sin(inc);0 -sin(inc) cos(inc)];
C3 = [cos(RAAN) sin(RAAN) 0;-sin(RAAN) cos(RAAN) 0;0 0 1];
    
Ct = C1*C2*C3;
C = Ct.';
