function COEs = rv2COEs(r,v)
% Takes in position and velocity vector and outputs COEs a vector of the 6
% classical orbital elements and some other useful information about the
% orbit for earth orbits.
% INPUTS:
% r, position vector
% v, velocity vector
% OUTPUTS:
% COEs, vector of useful information formated as following:
% [|angular momentum|,inclination,RAAN,eccentricity,argument of
% periapse,true anomaly,semimajor axis,time since periapse,period,specific
% energy,Eccentric anomaly]
% [h,inc,RAAN,ecc,omega,trueAnomal,semimajorA,t,period,Energy,E];


% mu_earth value
mu = 398600; % km3/s2

% magnitude of position/velocity
rmag = norm(r); %km
vmag = norm(v); %km/s
% radial velocity
radV = dot(r,v)/rmag; %km/s
% angular velocity
h = cross(r,v); %km2/s
hmag = norm(h); %km2/s
% inclination and node line
inc = acos(h(3)/hmag); %radians
nodeLine = cross([0;0;1],h);
nodeLineMag = norm(nodeLine);
% Right ascension of ascending node
if nodeLine(2) >= 0
    RAAN = acos(nodeLine(1)/nodeLineMag); %radians
else
    RAAN = 2*pi - acos(nodeLine(1)/nodeLineMag); %radians
end
% eccentricity
eccVec = 1/mu*((vmag^2-mu/rmag)*r-rmag*radV*v);
ecc = norm(eccVec); % eccentricity
% argument of periapse
if eccVec(3) >= 0
    omega = acos(dot(nodeLine,eccVec)/(nodeLineMag*ecc)); % radians
else
    omega = 2*pi - acos(dot(nodeLine,eccVec)/(nodeLineMag*ecc)); % radians
end
% true anomaly
if radV >= 0
    theta = acos(dot(eccVec,r)/(ecc*rmag)); % radians
else
    theta = 2*pi - acos(dot(eccVec,r)/(ecc*rmag)); % radians
end
% specific energy
Energy = .5*vmag^2-mu/rmag; % km2/s2
% semimajor axis
a = - mu/(2*Energy); % km
% Eccentric Anomaly
E = 2*atan(sqrt((1-ecc)/(1+ecc))*tan(theta/2)); % radians, Eccentric anomaly
% Mean anomaly
Me = E - ecc*sin(E);
% time since periapse
time = (hmag^3/mu^2)*Me/(1-ecc^2)^(3/2); % seconds
% period
period = 2*pi*a^(3/2)/sqrt(mu); % seconds


COEs.h = hmag; % angular momentum km2/s
COEs.inc = inc; % inclination radians
COEs.RAAN = RAAN; % Right ascension of ascending node radians
COEs.ecc = ecc; % eccentricity
COEs.omega = omega; % argument of periapse radians
COEs.TrueAnomaly = theta; % True Anomaly radians
COEs.a = a; % semimajor axis km
COEs.time = time; % time since perigee seconds
COEs.period = period; % period seconds
COEs.Energy = Energy; % Energy km2/s2
COEs.E = E; % Eccentric Anomaly radians



