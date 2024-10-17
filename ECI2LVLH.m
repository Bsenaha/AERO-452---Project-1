function [C_ECI2LVLH] = ECI2LVLH(R, V)
% ECI2LVLH 

% INPUT:
% R = ECI position vector [km]
% V = ECI velocity vector [km/s]

% OUTPUT:
% C_ECI2LVLH = rotation matrix from ECI to LVLH

% calculate h
h = cross(R,V);

% define i, j ,k
i = R / norm(R);
k = h / norm(h);
% ablah
j = cross(k, i);

% create rotation matrix
C_ECI2LVLH = [i(1), i(2), i(3);
              j(1), j(2), j(3);
              k(1), k(2), k(3)];
