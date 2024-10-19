%% AERO 452 - SPACEFLIGHT DYNAMICS PROJECT 1

% CALEB ARBRETON, BRANDON SENAHA
% MAIN PROJECT SCRIPT

clc; clear; close all

% global use
mu_Earth = 398600; % [km^3/s2]
options = odeset('RelTol',1e-8,'AbsTol',1e-8);
deltav_tot = 0; % initialize delta v [km/s] 
t_mission = 0; % initialize current mission time [s]

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

disp("--------------------------------------------------------------------")
disp("     ===     ID CHASER ORBIT     ===     ")


disp("--------------------------------------------------------------------")
%% ===== DEFINING STATES =====

disp("--------------------------------------------------------------------")
disp("     ===     DEFINING STATES     ===     ")

disp("--------------------------------------------------------------------")
%% ===== HOLD 1 =====

disp("--------------------------------------------------------------------")
disp("     ===     HOLD 1     ===     ")
% ** Remaining on same orbit as target 100km downrange for one period

% --- LVLH CALCULATIONS ---
% No specific LVLH calcs required

% update time
dt_hold1 = OPS_orbit.P; % hold duration [s]
[t_mission] = missiontime(t_mission, dt_hold1);
disp("--------------------------------------------------------------------")
%% ===== MANEUVER 1 =====

disp("--------------------------------------------------------------------")
disp("     ===     MANEUVER 1     ===     ")
% ** Vbar Hop from 100km to 40km downrange

% --- LVLH CALCULATIONS ---
% define maneuver parameters
downrange = 100; %[km]
y = -60; %[km]

% call hop function
[t_man1, deltav_man1, h_man1, out_man1] = hop(downrange, y, OPS_orbit.P);
% assign outputs
man1_R = out_man1(:,1:3); %[km]

% update time
dt_man1 = t_man1(end); % maneuver 1 duration [s]
[t_mission] = missiontime(t_mission, dt_man1);
disp("--------------------------------------------------------------------")
%% ===== HOLD 2 =====
disp("--------------------------------------------------------------------")
disp("     ===     HOLD 2     ===     ")
% ** Football maneuver into 40kmx20km relative orbit and hold

% --- LVLH CALCULATIONS ---
% define hold parameters
downrange = man1_R(end, 2); %[km]

% call hold function
[t_hold2, deltav_hold2, out_hold2] = Football(downrange, OPS_orbit.P);
% assign outputs
hold2_R = out_hold2(:,1:3);
hold2_V = out_hold2(:, 4:6);

% update time
dt_hold2 = t_hold2(end); % maneuver 1 duration [s]
[t_mission] = missiontime(t_mission, dt_hold2);
disp("--------------------------------------------------------------------")
%% ===== MANEUVER 2 =====

disp("--------------------------------------------------------------------")
disp("     ===     MANEUVER 2     ===     ")
% ** Vbar Hop from 40km to 1km downrange

% --- LVLH CALCULATIONS ---
% define maneuver parameters
downrange = 40; %[km]
y = -39; %[km]

% call hop function
[t_man2, deltav_man2, h_man2, out_man2] = hop(downrange, y, OPS_orbit.P);
% assign outputs
man2_R = out_man2(:,1:3); %[km]

% update time
dt_man2 = t_man2(end); % maneuver 1 duration [s]
[t_mission] = missiontime(t_mission, dt_man2);
disp("--------------------------------------------------------------------")
%% ===== HOLD 3 =====

disp("--------------------------------------------------------------------")
disp("     ===     HOLD 3     ===     ")
% * Hold @ 1km rel. distance *

% --- LVLH CALCULATIONS ---
% No specific LVLH calcs required

% update time
dt_hold3 = OPS_orbit.P; % hold duration [s]
[t_mission] = missiontime(t_mission, dt_hold3);
disp("--------------------------------------------------------------------")
%% ===== MANEUVER 3 =====

disp("--------------------------------------------------------------------")
disp("     ===     MANEUVER 3     ===     ")
% ** Vbar Hop from 1km to 300m downrange

% --- LVLH CALCULATIONS ---
% define maneuver parameters
downrange = 1; %[km]
y = -.7; %[km]

% call hop function
[t_man3, deltav_man3, h_man3, out_man3] = hop(downrange, y, OPS_orbit.P);
% assign outputs
man3_R = out_man3(:,1:3); %[km]

% update time
dt_man3 = t_man3(end); % maneuver 1 duration [s]
[t_mission] = missiontime(t_mission, dt_man3);
disp("--------------------------------------------------------------------")
%% ===== HOLD 4 =====

disp("--------------------------------------------------------------------")
disp("     ===     HOLD 4     ===     ")
% * Hold @ 300m rel. distance *

% --- LVLH CALCULATIONS ---
% No specific LVLH calcs required

% update time
dt_hold4 = OPS_orbit.P; % hold duration [s]
[t_mission] = missiontime(t_mission, dt_hold4);
disp("--------------------------------------------------------------------")
%% ===== MANEUVER 4 =====

disp("--------------------------------------------------------------------")
disp("     ===     MANEUVER 4     ===     ")
% ** Vbar Hop from 1km to 20m downrange

% --- LVLH CALCULATIONS ---
% define maneuver parameters
downrange = .3; %[km]
y = -0.28; %[km]

% call hop function
[t_man4, deltav_man4, h_man4, out_man4] = hop(downrange, y, OPS_orbit.P);
% assign outputs
man4_R = out_man4(:,1:3); %[km]

% update time
dt_man4 = t_man4(end); % maneuver 1 duration [s]
[t_mission] = missiontime(t_mission, dt_man4);
disp("--------------------------------------------------------------------")
%% ===== HOLD 5 =====

disp("--------------------------------------------------------------------")
disp("     ===     HOLD 5     ===     ")
% ** Football maneuver into 20mx10m relative orbit and hold for *TWO DAYS*

% --- LVLH CALCULATIONS ---
% define hold parameters
downrange = man4_R(end, 2); %[km]

% call hold function
[t_hold5, deltav_hold5, out_hold5] = Football(downrange, 2*OPS_orbit.P);
% assign outputs
hold5_R = out_hold5(:,1:3);
hold5_V = out_hold5(:, 4:6);

% update time
dt_hold5 = t_hold5(end); % maneuver 1 duration [s]
[t_mission] = missiontime(t_mission, dt_hold5);
disp("--------------------------------------------------------------------")
%% ===== MANEUVER 5 =====

disp("--------------------------------------------------------------------")
disp("     ===     MANEUVER 5     ===     ")
% ** FINALL APPROACH - Vbar approach from 20m with slight rel. velocity
% timing: completes 10 day capture

% --- LVLH CALCULATIONS ---
% define maneuver parameters
downrange = hold5_R(end, 2); %[km]

% set time to complete 10 days [km/s]
t_tenD = 10 * 24 * 60 * 60; % 10 days in [s]
t_remain = t_tenD - t_mission; % remaining mission time [s]
dt = t_remain; %[s]
vc = -downrange/t_remain; % set time to complete 10 days[km/s]

[t_man5, out_man5] = Vbar(downrange, vc, OPS_orbit.P, dt);
% assign outputs
man5_R = out_man5(:,1:3);

% update time
dt_man5 = t_man5(end); % maneuver 1 duration [s]
[t_mission] = missiontime(t_mission, dt_man5);
disp("--------------------------------------------------------------------")
%% ===== RESULTS =====

disp("--------------------------------------------------------------------")
disp("     ===     RESULTS     ===     ")

%% PLOTS
% man(num)_R = maneuver states
% hold(num)_R = hold states
% **uncomment to plot**

% --- LVLH PLOTS ---
% Maneuver and Hold plots
% plotLVLH(man1_R, man2_R, man3_R, man4_R, man5_R, hold2_R, hold5_R)

% hold 1 relative velocity plot

% --- ECI PLOTS ---
