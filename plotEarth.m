% plotEarth function
function plotEarth

% make sphere and define Earth size
r_Earth = 6378; %[km]
r_sphere = r_Earth / 2;
[X,Y,Z] = sphere;

% plot
surf(r_sphere*X,r_sphere*Y,r_sphere*Z)
