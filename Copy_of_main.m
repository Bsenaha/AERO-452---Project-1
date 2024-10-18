%% AERO 452 - SPACEFLIGHT DYNAMICS PROJECT 1

% CALEB ARBRETON, BRANDON SENAHA
% MAIN PROJECT SCRIPT

clc; clear; close all

% global use
mu_Earth = 398600; % [km^3/s2]
options = odeset('RelTol',1e-8,'AbsTol',1e-8);

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

disp("===== ID CHASER ORBIT =====")

disp(" ")
%% ===== DEFINING STATES =====

disp("===== DEFINING STATES =====")


disp(" ")
%% ===== MANEUVER 1 =====

disp("===== MANEUVER 1 =====")
% ** describe maneuver 
% 100km to 40km hop

% LVLH CALCULATIONS
% define hop parameters
downrange = 100; 
y = -60;

% call hop function
[t1, deltav_y1, h1, out1] = hop(downrange, y, OPS_orbit.P);

% assign outputs
man1_R = out1(:,1:3); %[km]

disp(" ")
%% ===== HOLD 1 =====

disp("===== HOLD 1 =====")

% define hold parameters

disp(" ")
%% ===== MANEUVER 2 =====

disp("===== MANEUVER 2 =====")

% * Burn from current orbit to Target orbit @ 1km rel. distance ahead of target *

disp(" ")
%% ===== HOLD 2 =====

disp("===== HOLD 2 =====")

% * Hold @ 1km rel. distance *

disp(" ")
%% ===== MANEUVER 3 =====

disp("===== MANEUVER 3 =====")

% * Vbar Hop Burn from 1km rel. distance to 300m rel. distance *

disp(" ")
%% ===== HOLD 3 =====

disp("===== HOLD 3 =====")

% * Hold @ 300m rel. distance *

disp(" ")
%% ===== MANEUVER 4 =====

disp("===== MANEUVER 4 =====")

% * Vbar Hop Burn from 300m rel. distance to 20m rel. distance *

disp(" ")
%% ===== HOLD 4 (FINAL HOLD) =====

disp("===== HOLD 4 =====")

% * Hold @ 20m rel. distance *

disp(" ")
%% ===== RESULTS =====

disp("===== RESULTS =====")
