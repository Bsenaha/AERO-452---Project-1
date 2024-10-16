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
[OPS.R_peri, OPS.V_peri] = COES2RV(OPS_orbit.theta, OPS_orbit.rpMag, OPS_orbit.ecc, mu_Earth); % perifocal
% convert to ECI
C_peri2ECI = peri2ECI(OPS_orbit.omega, OPS_orbit.inc, OPS_orbit.RAAN);
OPS.R_ECI = C_peri2ECI * OPS.R_peri; % ECI [km]
OPS.V_ECI = C_peri2ECI * OPS.V_peri; % ECI [km/s]

% Initialize

% Solve for Chaser initial position (100 km) on same orbit
rho_missionstart = 100; %[km]
% calc position and chaser theta
[CABS.R_peri, CABS_orbit.theta] = PositionSolver(OPS_orbit.theta, OPS_orbit.rpMag, OPS_orbit.ecc, mu_Earth, 100); % perifocal
CABS.R_ECI = C_peri2ECI * CABS.R_peri; % ECI [km] ** Initial Chaser Position in ECI **

%% ===== DEFINING STATES =====

% Redefine Target RV


% Define Chaser RV



%% ===== MANEUVER 1 =====



%% ===== HOLD 1 =====

% Define Hold Duration

% Propogate

%% ...



%% ===== RESULTS =====

