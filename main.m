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
%   1. 20-40 km (w/ small rel speed on order of m/s)
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


%% ===== DEFINING STATES =====

disp("===== DEFINING STATES =====")


%% ===== MANEUVER 1 =====

disp("===== MANEUVER 1 =====")
% ** Vbar Hop from 100km to 40km downrange

% --- LVLH CALCULATIONS ---
% define maneuver parameters
downrange = 100; %[km]
y = -60; %[km]

% call hop function
[t_man1, deltav_man1, h_man1, out_man1] = hop(downrange, y, OPS_orbit.P);
% assign outputs
man1_R = out_man1(:,1:3); %[km]


%% ===== HOLD 1 =====

disp("===== HOLD 1 =====")
% ** Football maneuver into 40kmx20km relative orbit and hold

% --- LVLH CALCULATIONS ---
% define hold parameters
downrange = man1_R(end, 2); %[km]

% call hold function
[t_hold1, deltav_hold1, out_hold1] = Football(downrange, OPS_orbit.P);
% assign outputs
hold1_R = out_hold1(:,1:3);
hold1_V = out_hold1(:, 4:6);


%% ===== MANEUVER 2 =====

disp("===== MANEUVER 2 =====")
% ** Vbar Hop from 40km to 1km downrange

% --- LVLH CALCULATIONS ---
% define maneuver parameters
downrange = 40; %[km]
y = -39; %[km]

% call hop function
[t_man2, deltav_man2, h_man2, out_man2] = hop(downrange, y, OPS_orbit.P);
% assign outputs
man2_R = out_man2(:,1:3); %[km]


%% ===== HOLD 2 =====

disp("===== HOLD 2 =====")

% * Hold @ 1km rel. distance *


%% ===== MANEUVER 3 =====

disp("===== MANEUVER 3 =====")
% ** Vbar Hop from 1km to 300m downrange

% --- LVLH CALCULATIONS ---
% define maneuver parameters
downrange = 1; %[km]
y = -.7; %[km]

% call hop function
[t_man3, deltav_man3, h_man3, out_man3] = hop(downrange, y, OPS_orbit.P);
% assign outputs
man3_R = out_man3(:,1:3); %[km]


%% ===== HOLD 3 =====

disp("===== HOLD 3 =====")

% * Hold @ 300m rel. distance *


%% ===== MANEUVER 4 =====

disp("===== MANEUVER 4 =====")
% ** Vbar Hop from 1km to 20m downrange

% --- LVLH CALCULATIONS ---
% define maneuver parameters
downrange = .3; %[km]
y = -0.28; %[km]

% call hop function
[t_man4, deltav_man4, h_man4, out_man4] = hop(downrange, y, OPS_orbit.P);
% assign outputs
man4_R = out_man4(:,1:3); %[km]


%% ===== MANEUVER 5 =====

disp("===== MANEUVER 5 =====")

% ** FINALL APPROACH - Vbar approach from 20m with slight rel. velocity

% --- LVLH CALCULATIONS ---
% define maneuver parameters
downrange = .02; %[km]
vc = -downrange/OPS_orbit.P; %[km/s]
dt = OPS_orbit.P; %[s]

[t_man5, out_man5] = Vbar(downrange, vc, OPS_orbit.P, dt);
% assign outputs
man5_R = out_man5(:,1:3);

%% ===== RESULTS =====

disp("===== RESULTS =====")

%% PLOTS
% man(num)_R = maneuver states
% hold(num)_R = hold states
% **uncomment to plot**

% --- LVLH PLOTS ---
% call plots
% plotLVLH(man1_R, man2_R, man3_R, man4_R, man5_R, hold1_R)
