function [R,V] = COES2RV(theta, rp, ecc, mu)
% inputs:
% mu = planet mu %[km3/s2]
% ecc = orbit eccentricity
% rp = periapse radius [km]
% theta = true anomaly [rad]

% outputs:
% R = SC position vector (perifocal) %[km]
% V = SC velocity vector (perifocal) %[km/s]

% Calculate h
h = sqrt(mu * (1 + ecc) * rp);

% Calculate R V (perifocal)
R = ((h^2) / (mu * (1 + ecc * cos(theta)))) * [cos(theta);sin(theta);0];
V = (mu/h)*[-sin(theta);(ecc+cos(theta));0];
end
