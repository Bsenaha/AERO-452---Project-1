%% AERO 452 - SPACEFLIGHT DYNAMICS PROJECT 1

% CALEB ARBRETON, BRANDON SENAHA
% MAIN PROJECT SCRIPT

clc; clear; close all

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

% Heavens above orbit link:
% https://www.heavens-above.com/orbit.aspx?satid=2207&lat=0&lng=0&loc=Unspecified&alt=0&tz=UCT&cul=en

%% ===== TLE PROCESSING =====

% Initialize TLE
OPS_TLE_read = tleread('TLE'); % using MATLAB's built-in
OPS_TLE = TLE_init(OPS_TLE_read); % convert and update
clear OPS_TLE_read

%% ===== ID CHASER ORBIT =====

% Get RV from COES

% Solve for 100km away on same orbit


%% ===== DEFINING STATES =====



%% ===== MANEUVER 1 =====



%% ===== HOLD 1 =====

% Define Hold Duration

% Propogate

%% ...



%% ===== RESULTS =====

