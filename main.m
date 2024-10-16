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
% Convert to ECI
C_peri2ECI = peri2ECI(OPS_orbit.omega, OPS_orbit.inc, OPS_orbit.RAAN);
OPS.R_ECI = C_peri2ECI * OPS.R_peri; % ECI [km]
OPS.V_ECI = C_peri2ECI * OPS.V_peri; % ECI [km/s]


% Solve for Chaser initial position (100 km) on lower altitude orbit
rho_missionstart = 100; %[km]


%% ===== DEFINING STATES =====

% Redefine Target RV


% Define Chaser RV

% Define initial relative velocity



%% ===== MANEUVER 1 =====

% * Cruise from 100km to 35 km *

%% ===== HOLD 1 =====

% * Hold/Cruise from 35km to 25km *

% * Additional holding? *

%% ===== MANEUVER 2 =====

% * Burn from current orbit to Target orbit @ 1km rel. distance ahead of target *

%% ===== HOLD 2 =====

% * Hold @ 1km rel. distance *

%% ===== MANEUVER 3 =====

% * Vbar Burn from 1km rel. distance to 300m rel. distance *

%% ===== HOLD 3 =====

% * Hold @ 300m rel. distance *

%% ===== MANEUVER 4 =====

% * Vbar Burn from 300m rel. distance to 20m rel. distance *

%% ===== HOLD 4 (FINAL HOLD) =====

% * Hold @ 20m rel. distance *

%% ===== RESULTS =====

