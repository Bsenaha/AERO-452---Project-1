function [TLEstruct] = TLE_init(TLE_file, mu)
% TLE Initialization

% INPUT
% TLE_file = raw TLE file

% OUTPUT
% TLEstruct = TLE struct updated with other necessary vals

% function takes in tle struct from tleread, updates and outputs tle struct
% with all other necessary orbital elements

TLE = tleread(TLE_file); % using MATLAB's built-in

% reassign existing with correct units
TLEstruct.epoch = TLE.Epoch; % Epoch date
TLEstruct.MM = TLE.MeanMotion * 240; % mean motion [rev/day]
TLEstruct.inc = deg2rad(TLE.Inclination); % inclination [rad]
TLEstruct.RAAN = deg2rad(TLE.RightAscensionOfAscendingNode); % RAAN [rad]
TLEstruct.ecc = TLE.Eccentricity; % eccentricity
TLEstruct.omega = deg2rad(TLE.ArgumentOfPeriapsis); % argument of periapse [rad]
TLEstruct.MA = deg2rad(TLE.MeanAnomaly); % mean anomaly [rad]

TLEstruct.E = EccentricAnomalyNewtons(TLEstruct.ecc, TLEstruct.MA); % eccentric anomaly at epoch [rad]
TLEstruct.theta = 2 * atan2(tan(TLEstruct.E / 2) * sqrt(1 + TLEstruct.ecc), sqrt(1 - TLEstruct.ecc)); % true anomaly [rad]

TLEstruct.P = 86400/TLEstruct.MM; % Period [sec]
TLEstruct.a = (sqrt(mu) * TLEstruct.P / (2 * pi))^(2 / 3); % semimajor axis of orbit [km]
TLEstruct.h = sqrt(TLEstruct.a * mu * (1 - TLEstruct.ecc^2)); % specific angular momentum [km2/s]
TLEstruct.Energy = -.5 * mu / TLEstruct.a; % specific energy [km2/s2]
TLEstruct.rpMag = TLEstruct.h^2 / (mu * (1 + TLEstruct.ecc)); % radius of perigee magnitude [km]
TLEstruct.raMag = TLEstruct.h^2 / (mu * (1 - TLEstruct.ecc)); % radius of apogee magnitude [km]
end

% Eccentric Anomaly Solver (Newton's Method)
function E = EccentricAnomalyNewtons(ecc,Me)
% outputs eccentric anomaly given mean anomaly and eccentricity

% functions for newton's method
fofE = @(E)Me - E + ecc*sin(E);
fprimeE = @(E)-1+ecc*cos(E);

% setting initial guess based off of mean anomaly
if Me > pi
    E(1) = Me+ecc/2;
else
    E(1) = Me-ecc/2;
end

% setting second guess
m = 1;
E(m+1) = E(1) - fofE(E(m))/fprimeE(E(m));

% iterating thru newton's method
while abs(E(m+1)-E(m)) > 10^-8
    % Checking to see if count exceeds 1000
    if m > 1000
        err("Newton's Method does not appear to converge using" + ...
            "given inputs")
    end
    m = m+1;
    E(m+1) = E(m) - fofE(E(m))/fprimeE(E(m));
end

% Eccentric anomaly is the final value from newton's method. 
E = E(end);
end
