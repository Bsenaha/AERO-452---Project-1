%% AERO 452 - SPACEFLIGHT DYNAMICS PROJECT 1

% CALEB ARBRETON, BRANDON SENAHA
% MAIN PROJECT SCRIPT

clc; clear; close all

% global use
mu_Earth = 398600; % [km^3/s2]

%% ===== PROJECT INFORMATION =====

% Total Time to Capture (TTC): 10 days
% Initial Relative Distance: 100 km

% Holds:
%   1. 20-40 km (w/ small rel speed)
%   2. 1     km
%   3. 0.300 km
%   4. 20    m  (w/ small rel speed)

% Satellite Information
% Name: OPS 9381 (GGTS)
% **will be referenced as "OPS"**
% Orbit Type: GEO

% Chaser Information
% Name: CABS

% Heavens above orbit link:
% https://www.heavens-above.com/orbit.aspx?satid=2207&lat=0&lng=0&loc=Unspecified&alt=0&tz=UCT&cul=en

%% ===== TLE PROCESSING =====

% Initialize TLE
OPS_orbit = TLE_init('TLE', mu_Earth); % convert and update

%% ===== ID CHASER ORBIT =====

% Get Target RV from COES
[OPS.R, OPS.V] = COES2RV(OPS_orbit.theta, OPS_orbit.rpMag, OPS_orbit.ecc, mu_Earth); % perifocal
C_peri2ECI = peri2ECI(OPS_orbit.omega, OPS_orbit.inc, OPS_orbit.RAAN);
OPS.R = C_peri2ECI * OPS.R; % ECI [km]
OPS.V = C_peri2ECI * OPS.V; % ECI [km/s]

% Solve for Chaser initial position (100 km) on same orbit
rho_missionstart = 100; %[km]
[CABS.R] = PositionSolver(OPS_orbit.theta, OPS_orbit.omega, OPS_orbit.inc, OPS_orbit.RAAN, OPS_orbit.rpMag, OPS_orbit.ecc, mu_Earth, 100);


%% ===== DEFINING STATES =====



%% ===== MANEUVER 1 =====



%% ===== HOLD 1 =====

% Define Hold Duration

% Propogate

%% ...



%% ===== RESULTS =====

