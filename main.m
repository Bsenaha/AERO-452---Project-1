%% AERO 452 - SPACEFLIGHT DYNAMICS PROJECT 1

% CALEB ARBRETON, BRANDON SENAHA
% MAIN PROJECT SCRIPT

clc; clear; close all

% global use
mu_Earth = 398600; % [km^3/s2]
options = odeset('RelTol',1e-8,'AbsTol',1e-8);
dt_24 = 24 * 60 * 60; % 24 hours in seconds
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
% Name: LES 6
% **will be referenced as "LES"**
% Orbit Type: GEO

% Chaser Information
% Name: CABS

% Heavens above orbit link:
% https://www.heavens-above.com/SatInfo.aspx?satid=3431&lat=0&lng=0&loc=Unspecified&alt=0&tz=UCT

%% ===== TLE PROCESSING =====

% Initialize TLE
LES_orbit = TLE_init('TLE', mu_Earth); % convert and update

%% ===== ID CHASER ORBIT =====

% Get Target starting RV from COES
[LES.R_peri, LES.V_peri] = COES2RV(LES_orbit.theta, LES_orbit.rpMag, LES_orbit.ecc, mu_Earth); % perifocal
% Convert to ECI
C_peri2ECI = peri2ECI(LES_orbit.omega, LES_orbit.inc, LES_orbit.RAAN);
LES.R_ECI = C_peri2ECI * LES.R_peri; % ECI [km]
LES.V_ECI = C_peri2ECI * LES.V_peri; % ECI [km/s]

% Propogate target to Mission Launch Date (Nov. 1st 2024)
datetime_missionstart = datetime('2024-11-01 00:00:00'); 
t2missionstart = etime(datevec(datetime_missionstart), datevec(LES_orbit.epoch));

y0 = [LES.R_ECI; LES.V_ECI];
[~, LES.R_ECI, LES.V_ECI, ~, ~] = propogate(t2missionstart, y0, options, mu_Earth);

% Defining Chaser COES
% All are the same except rp and theta
CABS_orbit = LES_orbit; % clone target orbit to chaser

% Recalculate new COEs based new R and Vs
COEs_temp = rv2COEs(LES.R_ECI, LES.V_ECI);
LES_orbit.theta = COEs_temp.TrueAnomaly; % only COE that matters after prop

% Solving for Chaser initial position on same orbit (100 km in front):
rho_missionstart = 100; %[km]
[CABS.R_peri, CABS_orbit.theta] = PositionSolver(LES_orbit.theta, LES_orbit.rpMag, CABS_orbit.rpMag, LES_orbit.ecc, mu_Earth, rho_missionstart); % perifocal

%% ===== DEFINING STATES =====

disp("--------------------------------------------------------------------")
disp("     ===     DEFINING STATES     ===     ")

% --- ECI CALCULATIONS ---
% Redefine Target RV
[LES.R_peri, LES.V_peri] = COES2RV(LES_orbit.theta, LES_orbit.rpMag, LES_orbit.ecc, mu_Earth);
% Convert to ECI
LES.R_ECI = C_peri2ECI * LES.R_peri;
LES.V_ECI = C_peri2ECI * LES.V_peri;

% Define Chaser RV based on previously found rp and theta
[CABS.R_peri, CABS.V_peri] = COES2RV(CABS_orbit.theta, CABS_orbit.rpMag, CABS_orbit.ecc, mu_Earth);
% Convert to ECI
CABS.R_ECI = C_peri2ECI * CABS.R_peri; % ECI [km]
CABS.V_ECI = C_peri2ECI * CABS.V_peri; % ECI [km/s]

% PLOT
%{
% plot mission start positions
% -- ORBIT
y0 = [LES.R_ECI; LES.V_ECI];
[t, state] = ode45(@tbsMotion, [0 LES_orbit.P], y0, options, mu_Earth);

figure()
e(1) = plot3(LES.R_ECI(1), LES.R_ECI(2), LES.R_ECI(3), '.', 'MarkerSize', 10, 'Color', 'r'); % Target R
hold on
e(2) = plot3(CABS.R_ECI(1), CABS.R_ECI(2), CABS.R_ECI(3), '.', 'MarkerSize', 10, 'Color', 'b'); % Chaser R
e(3) = plot3(state(:,1), state(:,2), state(:,3), '-.', 'Color', 'k'); % Target Orbit
run('plotEarth');
axis equal
xlabel('X ECI [km]')
ylabel('Y ECI [km]')
zlabel('Z ECI [km]')
title('Mission Start Position in ECI')
zlim([-2e4 2e4])
legend('LES Position', 'CABS Position', 'Orbit')
grid on
%}

disp("--------------------------------------------------------------------")
%% ===== HOLD 1 =====

disp("--------------------------------------------------------------------")
disp("     ===     HOLD 1     ===     ")
% ** Remaining on same orbit as target 100km downrange for one period

% --- LVLH CALCULATIONS ---
% No specific LVLH calcs required

% --- ECI CALCULATIONS ---
% redefine states before maneuver
LES.R_ECI = LES.R_ECI; %[km]
LES.V_ECI = LES.V_ECI; %[km/s]

CABS.R_ECI = CABS.R_ECI; %[km]
CABS.V_ECI = CABS.V_ECI; %[km/s]

% --- DELTA V CALCULATIONS ---
deltav_hold1 = [0; 0; 0];

% disp delta v
deltav_tot = deltav_tot + norm(deltav_hold1);
disp("Maneuver delta v (ECI) [m/s]: ")
disp(1000*deltav_hold1)
disp("Total Manuever delta v [m/s]: " + 1000*norm(deltav_hold1))
disp("Total Mission delta v Expenditure [m/s]: " + 1000*deltav_tot)

% --- PROPOGATE ---
% hold:
dt_hold1 = 2*dt_24-312; % hold 1 duration [s]

% propogate target
y0_hold1_LES = [LES.R_ECI; LES.V_ECI];
[~, LES.R_ECI, LES.V_ECI, hold1_R_LES, hold1_V_LES] = propogate(dt_hold1, y0_hold1_LES, options, mu_Earth);

% propogate chaser
y0_hold1_CABS = [CABS.R_ECI; CABS.V_ECI];
[~, CABS.R_ECI, CABS.V_ECI, hold1_R_CABS, hold1_V_CABS] = propogate(dt_hold1, y0_hold1_CABS, options, mu_Earth);

% --- PLOT ---
%{
figure()
r(1) = plot3(hold1_R_LES(:, 1), hold1_R_LES(:, 2), hold1_R_LES(:, 3), '-.'); % target orbit
hold on
r(2) = plot3(hold1_R_CABS(:,1), hold1_R_CABS(:,2), hold1_R_CABS(:,3), '-.'); % chaser orbit
run('plotEarth');
axis equal
xlabel('X ECI [km]')
ylabel('Y ECI [km]')
zlabel('Z ECI [km]')
title('Mission Start Position in ECI')
zlim([-2e4 2e4])
grid on
%}

% --- TIME CALCULATIONS ---
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
[t_man1, deltav_man1, h_man1, out_man1] = hop(downrange, y, LES_orbit.P);
% assign outputs
man1_R = out_man1(:,1:3); %[km]
dt_man1 = t_man1(end); % maneuver 1 duration [s]

% --- ECI CALCULATIONS ---
% define rotation
C_LVLH2ECI = LVLH2ECI(LES.R_ECI, LES.V_ECI);

% --- DELTA V CALCULATIONS ---
% define new velocity
deltav_man1_ECI = C_LVLH2ECI * deltav_man1; %[km/s]
CABS.V_ECI = CABS.V_ECI + deltav_man1_ECI; %[km/s]

% disp delta v
deltav_tot = deltav_tot + 2*norm(deltav_man1);
disp("Maneuver delta v (ECI) [m/s]: ")
disp(1000*deltav_man1_ECI)
disp("Total Manuever delta v [m/s]: " + 1000*norm(deltav_man1_ECI))
disp("Total Mission delta v Expenditure [m/s]: " + 1000*deltav_tot)

% --- PROPOGATE ---
% hop:
% propogate target
y0_man1_LES = [LES.R_ECI; LES.V_ECI];
[~, LES.R_ECI, LES.V_ECI, man1_R_LES, man1_V_LES] = propogate(dt_man1, y0_man1_LES, options, mu_Earth);

% propogate chaser
y0_man1_CABS = [CABS.R_ECI; CABS.V_ECI];
[~, CABS.R_ECI, CABS.V_ECI, man1_R_CABS, man1_V_CABS] = propogate(dt_man1, y0_man1_CABS, options, mu_Earth);

% apply second burn to reset chaser V
CABS.V_ECI = CABS.V_ECI - deltav_man1_ECI;

% --- PLOT ---
%{
figure()
r(1) = plot3(LES.R_ECI(1), LES.R_ECI(2), LES.R_ECI(3), '.', 'MarkerSize', 10, 'Color', 'r'); % Target R
hold on
r(2) = plot3(man1_R_LES(:, 1), man1_R_LES(:, 2), man1_R_LES(:, 3), '-.', 'Color', 'r'); % target orbit
r(3) = plot3(CABS.R_ECI(1), CABS.R_ECI(2), CABS.R_ECI(3), '.', 'MarkerSize', 10, 'Color', 'b'); % Chaser R
r(4) = plot3(man1_R_CABS(:,1), man1_R_CABS(:,2), man1_R_CABS(:,3), '-.', 'Color', 'b'); % chaser orbit
run('plotEarth');
axis equal
xlabel('X ECI [km]')
ylabel('Y ECI [km]')
zlabel('Z ECI [km]')
title('Maneuver 1: Hop Trajectory -- ECI')
zlim([-2e4 2e4])
legend('LES Position', 'LES Orbit', 'CABS Position', 'CABS Orbit')
grid on
%}

% --- TIME CALCULATIONS ---
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
[t_hold2, deltav_hold2, out_hold2] = Football(downrange, CABS_orbit.P);
% assign outputs
hold2_R = out_hold2(:, 1:3);
hold2_V = out_hold2(:, 4:6);

% --- ECI CALCULATIONS --
% define rotation
C_LVLH2ECI = LVLH2ECI(LES.R_ECI, LES.V_ECI);

% --- DELTA V / PROPOGATE CALCULATIONS ---
% define velocity to get onto hold
deltav_hold2_ECI = C_LVLH2ECI * deltav_hold2; %[km/s]
CABS.V_ECI = CABS.V_ECI + deltav_hold2_ECI; %[km/s]

% propogate football
dt_hold2 = t_hold2(end); % maneuver 2 duration [s]
% propogate target
y0_hold2_LES = [LES.R_ECI; LES.V_ECI];
[~, LES.R_ECI, LES.V_ECI, hold2on_R_LES, hold2on_V_LES] = propogate(dt_hold2, y0_hold2_LES, options, mu_Earth);

% at 1/4, 1/2, 3/4 period for plotting
[~, LES_14, ~, ~, ~] = propogate(dt_hold2*(1/4), y0_hold2_LES, options, mu_Earth);
[~, LES_12, ~, ~, ~] = propogate(dt_hold2*(1/2), y0_hold2_LES, options, mu_Earth);
[~, LES_34, ~, ~, ~] = propogate(dt_hold2*(3/4), y0_hold2_LES, options, mu_Earth);

% propogate chaser
y0_hold2_CABS = [CABS.R_ECI; CABS.V_ECI];
[~, CABS.R_ECI, CABS.V_ECI, hold2on_R_CABS, hold2on_V_CABS] = propogate(dt_hold2, y0_hold2_CABS, options, mu_Earth);

% at 1/4, 1/2, 3/4 period for plotting
[~, CABS_14, ~, ~, ~] = propogate(dt_hold2*(1/4), y0_hold2_CABS, options, mu_Earth);
[~, CABS_12, ~, ~, ~] = propogate(dt_hold2*(1/2), y0_hold2_CABS, options, mu_Earth);
[~, CABS_34, ~, ~, ~] = propogate(dt_hold2*(3/4), y0_hold2_CABS, options, mu_Earth);

% define velocity to get off hold
deltav_hold2off_ECI = -deltav_hold2_ECI; %[km/s]
CABS.V_ECI = CABS.V_ECI + deltav_hold2off_ECI; %[km/s]

% find remaining hold time
disp(dt_24 - dt_hold2)
dt_remain = dt_24 - dt_hold2; % remaining hold time [s]

% propogate remaining hold time
% propogate target
y0_hold2_LES = [LES.R_ECI; LES.V_ECI];
[~, LES.R_ECI, LES.V_ECI, hold2off_R_LES, hold2off_V_LES] = propogate(dt_remain, y0_hold2_LES, options, mu_Earth);

% propogate chaser
y0_hold2_CABS = [CABS.R_ECI; CABS.V_ECI];
[~, CABS.R_ECI, CABS.V_ECI, hold2off_R_CABS, hold2off_V_CABS] = propogate(dt_remain, y0_hold2_CABS, options, mu_Earth);

% disp delta v
deltav_tot = deltav_tot + 2*norm(deltav_hold2);
% first burn
disp("First Burn Maneuver delta v (ECI) [m/s]: ")
disp(1000*deltav_hold2_ECI)
disp("Total Manuever delta v [m/s]: " + 1000*norm(deltav_hold2_ECI))
disp(" ")

% second burn
disp("Second Burn Maneuver delta v (ECI) [m/s]: ")
disp(1000*deltav_hold2off_ECI)
disp("Total Manuever delta v [m/s]: " + 1000*norm(deltav_hold2off_ECI))
disp("Total Mission delta v Expenditure [m/s]: " + 1000*deltav_tot)

% --- PLOT ---
%{
figure()
r(1) = plot3(LES.R_ECI(1), LES.R_ECI(2), LES.R_ECI(3), '.', 'MarkerSize', 10, 'Color', 'r'); % Target R
hold on
r(2) = plot3(hold2on_R_LES(:, 1), hold2on_R_LES(:, 2), hold2on_R_LES(:, 3), '-.', 'Color', 'r'); % target orbit
r(3) = plot3(CABS.R_ECI(1), CABS.R_ECI(2), CABS.R_ECI(3), '.', 'MarkerSize', 10, 'Color', 'b'); % Chaser R
r(4) = plot3(hold2on_R_CABS(:, 1), hold2on_R_CABS(:, 2), hold2on_R_CABS(:, 3), '-.', 'Color', 'b'); % chaser orbit
r(5) = plot3(LES_14(1), LES_14(2), LES_14(3), '.', 'MarkerSize', 10, 'Color', 'r'); % Target R
r(6) = plot3(CABS_14(1), CABS_14(2), CABS_14(3), '.', 'MarkerSize', 10, 'Color', 'b'); % Chaser R
r(7) = plot3(LES_12(1), LES_12(2), LES_12(3), '.', 'MarkerSize', 10, 'Color', 'r'); % Target R
r(8) = plot3(CABS_12(1), CABS_12(2), CABS_12(3), '.', 'MarkerSize', 10, 'Color', 'b'); % Chaser R
r(9) = plot3(LES_34(1), LES_34(2), LES_34(3), '.', 'MarkerSize', 10, 'Color', 'r'); % Target R
r(10) = plot3(CABS_34(1), CABS_34(2), CABS_34(3), '.', 'MarkerSize', 10, 'Color', 'b'); % Chaser R
run('plotEarth');
axis equal
xlabel('X ECI [km]')
ylabel('Y ECI [km]')
zlabel('Z ECI [km]')
title('Hold 2: Football Trajectory -- ECI')
zlim([-2e4 2e4])
legend('LES Position', 'LES Orbit', 'CABS Position', 'CABS Orbit')
grid on
%}

% update time
[t_mission] = missiontime(t_mission, dt_hold2 + dt_remain);
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
[t_man2, deltav_man2, h_man2, out_man2] = hop(downrange, y, LES_orbit.P);
% assign outputs
man2_R = out_man2(:,1:3); %[km]
dt_man2 = t_man2(end); % maneuver 2 duration [s]

% --- ECI CALCULATIONS --
% define rotation
C_LVLH2ECI = LVLH2ECI(LES.R_ECI, LES.V_ECI);

% --- DELTA V CALCULATIONS ---
% define velocity to get onto hold
deltav_man2_ECI = C_LVLH2ECI * deltav_man2; %[km/s]
CABS.V_ECI = CABS.V_ECI + deltav_man2_ECI; %[km/s]

% disp delta v
deltav_tot = deltav_tot + 2*norm(deltav_man2);
disp("Maneuver delta v (ECI) [m/s]: ")
disp(1000*deltav_man2_ECI)
disp("Total Manuever delta v [m/s]: " + 1000*norm(deltav_man2_ECI))
disp("Total Mission delta v Expenditure [m/s]: " + 1000*deltav_tot)

% --- PROPOGATE ---
% hop:
y0_man2_LES = [LES.R_ECI; LES.V_ECI];
[~, LES.R_ECI, LES.V_ECI, man2_R_LES, man2_V_LES] = propogate(dt_man2, y0_man2_LES, options, mu_Earth);

% propogate chaser
y0_man2_CABS = [CABS.R_ECI; CABS.V_ECI];
[~, CABS.R_ECI, CABS.V_ECI, man2_R_CABS, man2off_V_CABS] = propogate(dt_man2, y0_man2_CABS, options, mu_Earth);

% --- PLOT --- 
%{
figure()
r(1) = plot3(LES.R_ECI(1), LES.R_ECI(2), LES.R_ECI(3), '.', 'MarkerSize', 10, 'Color', 'r'); % Target R
hold on
r(2) = plot3(man2_R_LES(:, 1), man2_R_LES(:, 2), man2_R_LES(:, 3), '-.', 'Color', 'r'); % target orbit
r(3) = plot3(CABS.R_ECI(1), CABS.R_ECI(2), CABS.R_ECI(3), '.', 'MarkerSize', 10, 'Color', 'b'); % Chaser R
r(4) = plot3(man2_R_CABS(:,1), man2_R_CABS(:,2), man2_R_CABS(:,3), '-.', 'Color', 'b'); % chaser orbit
run('plotEarth');
axis equal
xlabel('X ECI [km]')
ylabel('Y ECI [km]')
zlabel('Z ECI [km]')
title('Maneuver 2: Hop Trajectory -- ECI')
zlim([-2e4 2e4])
legend('LES Position', 'LES Orbit', 'CABS Position', 'CABS Orbit')
grid on
%}

% apply second burn to reset chaser V
CABS.V_ECI = CABS.V_ECI - deltav_man1_ECI;

% update time
[t_mission] = missiontime(t_mission, dt_man2);
disp("--------------------------------------------------------------------")
%% ===== HOLD 3 =====

disp("--------------------------------------------------------------------")
disp("     ===     HOLD 3     ===     ")
% * Hold @ 1km rel. distance *

% --- LVLH CALCULATIONS ---
% No specific LVLH calcs required

% --- ECI CALCULATIONS ---
% redefine states before maneuver
LES.R_ECI = LES.R_ECI; %[km]
LES.V_ECI = LES.V_ECI; %[km/s]

CABS.R_ECI = CABS.R_ECI; %[km]
CABS.V_ECI = CABS.V_ECI; %[km/s]

% --- DELTA V CALCULATIONS ---
deltav_hold3 = [0; 0; 0];

deltav_tot = deltav_tot + norm(deltav_hold3);
disp("Maneuver delta v (ECI) [m/s]: ")
disp(1000*deltav_hold3)
disp("Total Manuever delta v [m/s]: " + 1000*norm(deltav_hold3))
disp("Total Mission delta v Expenditure [m/s]: " + 1000*deltav_tot)

% --- PROPOGATE ---
% hold:
dt_hold3 = dt_24; % hold duration [s]

% propogate target
y0_hold3_LES = [LES.R_ECI; LES.V_ECI];
[~, LES.R_ECI, LES.V_ECI, hold3_R_LES, hold3_V_LES] = propogate(dt_hold3, y0_hold3_LES, options, mu_Earth);

% propogate chaser
y0_hold3_CABS = [CABS.R_ECI; CABS.V_ECI];
[~, CABS.R_ECI, CABS.V_ECI, hold3_R_CABS, hold3_V_CABS] = propogate(dt_hold3, y0_hold3_CABS, options, mu_Earth);
disp(norm(CABS.R_ECI - LES.R_ECI))

% --- PLOT ---
% no plot needed

% update time
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
[t_man3, deltav_man3, h_man3, out_man3] = hop(downrange, y, LES_orbit.P);
% assign outputs
man3_R = out_man3(:,1:3); %[km]

% --- ECI CALCULATIONS ---
% define rotation
C_LVLH2ECI = LVLH2ECI(LES.R_ECI, LES.V_ECI);

% --- DELTA V CALCULATIONS ---
% define velocity to get onto hold
deltav_man3_ECI = C_LVLH2ECI * deltav_man3; %[km/s]
CABS.V_ECI = CABS.V_ECI + deltav_man3_ECI; %[km/s]

% disp delta v
deltav_tot = deltav_tot + 2*norm(deltav_man3);
disp("Maneuver delta v (ECI) [m/s]: ")
disp(1000*deltav_man3_ECI)
disp("Total Manuever delta v [m/s]: " + 1000*norm(deltav_man3_ECI))
disp("Total Mission delta v Expenditure [m/s]: " + 1000*deltav_tot)

% --- PROPOGATE ---
% hop:
dt_man3 = t_man3(end); % maneuver 3 duration [s]

% propogate target
y0_man3_LES = [LES.R_ECI; LES.V_ECI];
[~, LES.R_ECI, LES.V_ECI, man3_R_LES, man3_V_LES] = propogate(dt_man3, y0_man3_LES, options, mu_Earth);

% propogate chaser
CABS.V_ECI = LES.V_ECI;
y0_man3_CABS = [LES.R_ECI; CABS.V_ECI];
[~, CABS.R_ECI, CABS.V_ECI, man3_R_CABS, man3_V_CABS] = propogate(dt_man3 + .1025, y0_man3_CABS, options, mu_Earth);

% --- PLOT ---
%{
figure()
r(1) = plot3(LES.R_ECI(1), LES.R_ECI(2), LES.R_ECI(3), '.', 'MarkerSize', 10, 'Color', 'r'); % Target R
hold on
r(2) = plot3(man3_R_LES(:, 1), man3_R_LES(:, 2), man3_R_LES(:, 3), '-.', 'Color', 'r'); % target orbit
r(3) = plot3(CABS.R_ECI(1), CABS.R_ECI(2), CABS.R_ECI(3), '.', 'MarkerSize', 10, 'Color', 'b'); % Chaser R
r(4) = plot3(man3_R_CABS(:,1), man3_R_CABS(:,2), man3_R_CABS(:,3), '-.', 'Color', 'b'); % chaser orbit
run('plotEarth');
axis equal
xlabel('X ECI [km]')
ylabel('Y ECI [km]')
zlabel('Z ECI [km]')
title('Maneuver 3: Hop Trajectory -- ECI')
zlim([-2e4 2e4])
legend('LES Position', 'LES Orbit', 'CABS Position', 'CABS Orbit')
grid on
%}

% update delta v
CABS.V_ECI = CABS.V_ECI - deltav_man3_ECI;

% update time
dt_man3 = t_man3(end); % maneuver 3 duration [s]
[t_mission] = missiontime(t_mission, dt_man3);
disp("--------------------------------------------------------------------")
%% ===== HOLD 4 =====

disp("--------------------------------------------------------------------")
disp("     ===     HOLD 4     ===     ")
% * Hold @ 300m rel. distance *

% --- LVLH CALCULATIONS ---
% No specific LVLH calcs required

% --- ECI CALCULATIONS ---
% redefine states before maneuver
LES.R_ECI = LES.R_ECI; %[km]
LES.V_ECI = LES.V_ECI; %[km/s]

CABS.R_ECI = CABS.R_ECI; %[km]
CABS.V_ECI = CABS.V_ECI; %[km/s]

% --- DELTA V CALCULATIONS ---
deltav_hold4 = [0; 0; 0];

deltav_tot = deltav_tot + norm(deltav_hold4);
disp("Maneuver delta v (ECI) [m/s]: ")
disp(1000*deltav_hold4)
disp("Total Manuever delta v [m/s]: " + 1000*norm(deltav_hold4))
disp("Total Mission delta v Expenditure [m/s]: " + 1000*deltav_tot)

% --- PROPOGATE ---
% hold:
dt_hold4 = dt_24; % hold duration [s]

% propogate target
y0_hold4_LES = [LES.R_ECI; LES.V_ECI];
[~, LES.R_ECI, LES.V_ECI, hold4_R_LES, hold4_V_LES] = propogate(dt_hold4, y0_hold4_LES, options, mu_Earth);

% propogate chaser
y0_hold4_CABS = [CABS.R_ECI; CABS.V_ECI];
[~, CABS.R_ECI, CABS.V_ECI, hold4_R_CABS, hold4_V_CABS] = propogate(dt_hold4, y0_hold4_CABS, options, mu_Earth);

% update time
[t_mission] = missiontime(t_mission, dt_hold4);
disp("--------------------------------------------------------------------")
%% ===== MANEUVER 4 =====

disp("--------------------------------------------------------------------")
disp("     ===     MANEUVER 4     ===     ")
% ** Vbar Hop from 300m to 20m downrange

% --- LVLH CALCULATIONS ---
% define maneuver parameters
downrange = .3; %[km]
y = -0.28; %[km]

% call hop function
[t_man4, deltav_man4, h_man4, out_man4] = hop(downrange, y, LES_orbit.P);
% assign outputs
man4_R = out_man4(:,1:3); %[km]

% --- ECI CALCULATIONS ---
% define rotation
C_LVLH2ECI = LVLH2ECI(LES.R_ECI, LES.V_ECI);

% --- DELTA V CALCULATIONS ---
% define velocity to get onto hold
deltav_man4_ECI = C_LVLH2ECI * deltav_man4; %[km/s]
CABS.V_ECI = CABS.V_ECI + deltav_man4_ECI; %[km/s]

% disp delta v
deltav_tot = deltav_tot + 2*norm(deltav_man4);
disp("Maneuver delta v (ECI) [m/s]: ")
disp(1000*deltav_man4_ECI)
disp("Total Manuever delta v [m/s]: " + 1000*norm(deltav_man4_ECI))
disp("Total Mission delta v Expenditure [m/s]: " + 1000*deltav_tot)

% --- PROPOGATE ---
% hop:
dt_man4 = t_man4(end); % maneuver 4 duration [s]

% propogate target
y0_man4_LES = [LES.R_ECI; LES.V_ECI];
[~, LES.R_ECI, LES.V_ECI, man4_R_LES, man4_V_LES] = propogate(dt_man4, y0_man4_LES, options, mu_Earth);

% propogate chaser
y0_man4_CABS = [LES.R_ECI; CABS.V_ECI];
[~, CABS.R_ECI, CABS.V_ECI, man4_R_CABS, man4_V_CABS] = propogate(dt_man4, y0_man4_CABS, options, mu_Earth);

% --- PLOT ---

figure()
r(1) = plot3(LES.R_ECI(1), LES.R_ECI(2), LES.R_ECI(3), '.', 'MarkerSize', 10, 'Color', 'r'); % Target R
hold on
r(2) = plot3(man4_R_LES(:, 1), man4_R_LES(:, 2), man4_R_LES(:, 3), '-.', 'Color', 'r'); % target orbit
r(3) = plot3(CABS.R_ECI(1), CABS.R_ECI(2), CABS.R_ECI(3), '.', 'MarkerSize', 10, 'Color', 'b'); % Chaser R
r(4) = plot3(man4_R_CABS(:,1), man4_R_CABS(:,2), man4_R_CABS(:,3), '-.', 'Color', 'b'); % chaser orbit
run('plotEarth');
axis equal
xlabel('X ECI [km]')
ylabel('Y ECI [km]')
zlabel('Z ECI [km]')
title('Maneuver 4: Hop Trajectory -- ECI')
zlim([-2e4 2e4])
legend('LES Position', 'LES Orbit', 'CABS Position', 'CABS Orbit')
grid on


% update delta v
CABS.V_ECI = CABS.V_ECI - deltav_man4_ECI;

% update time
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
[t_hold5, deltav_hold5, out_hold5] = Football(downrange, LES_orbit.P);
% assign outputs
hold5_R = out_hold5(:,1:3);
hold5_V = out_hold5(:, 4:6);

% --- ECI CALCULATIONS --
% define rotation
C_LVLH2ECI = LVLH2ECI(LES.R_ECI, LES.V_ECI);

% --- DELTA V / PROPOGATE CALCULATIONS ---
% define velocity to get onto hold
deltav_hold5_ECI = C_LVLH2ECI * deltav_hold5; %[km/s]
CABS.V_ECI = CABS.V_ECI + deltav_hold5_ECI; %[km/s]

% propogate football
dt_hold5 = t_hold5(end); % hold 5 duration [s]v
% propogate target
y0_hold5_LES = [LES.R_ECI; LES.V_ECI];
[~, LES.R_ECI, LES.V_ECI, hold5on_R_LES, hold5on_V_LES] = propogate(dt_hold5, y0_hold5_LES, options, mu_Earth);

% at 1/4, 1/2, 3/4 period for plotting
[~, LES_14, ~, ~, ~] = propogate(dt_hold5*(1/4), y0_hold2_LES, options, mu_Earth);
[~, LES_12, ~, ~, ~] = propogate(dt_hold5*(1/2), y0_hold2_LES, options, mu_Earth);
[~, LES_34, ~, ~, ~] = propogate(dt_hold5*(3/4), y0_hold2_LES, options, mu_Earth);

% propogate chaser
y0_hold5_CABS = [CABS.R_ECI; CABS.V_ECI];
[~, CABS.R_ECI, CABS.V_ECI, hold5on_R_CABS, hold5on_V_CABS] = propogate(dt_hold5, y0_hold5_CABS, options, mu_Earth);

% at 1/4, 1/2, 3/4 period for plotting
[~, CABS_14, ~, ~, ~] = propogate(dt_hold5*(1/4), y0_hold2_CABS, options, mu_Earth);
[~, CABS_12, ~, ~, ~] = propogate(dt_hold5*(1/2), y0_hold2_CABS, options, mu_Earth);
[~, CABS_34, ~, ~, ~] = propogate(dt_hold5*(3/4), y0_hold2_CABS, options, mu_Earth);

% define velocity to get off hold
deltav_hold5off_ECI = -deltav_hold5_ECI; %[km/s]
CABS.V_ECI = CABS.V_ECI + deltav_hold5off_ECI; %[km/s]

% disp delta v
deltav_tot = deltav_tot + 2*norm(deltav_hold5);
% first burn
disp("First Burn Maneuver delta v (ECI) [m/s]: ")
disp(1000*deltav_hold5_ECI)
disp("Total Manuever delta v [m/s]: " + 1000*norm(deltav_hold5_ECI))
disp(" ")

% second burn
disp("Second Burn Maneuver delta v (ECI) [m/s]: ")
disp(1000*deltav_hold5off_ECI)
disp("Total Manuever delta v [m/s]: " + 1000*norm(deltav_hold5off_ECI))
disp("Total Mission delta v Expenditure [m/s]: " + 1000*deltav_tot)


figure()
r(1) = plot3(LES.R_ECI(1), LES.R_ECI(2), LES.R_ECI(3), '.', 'MarkerSize', 10, 'Color', 'r'); % Target R
hold on
r(2) = plot3(hold5on_R_LES(:, 1), hold5on_R_LES(:, 2), hold5on_R_LES(:, 3), '-.', 'Color', 'r'); % target orbit
r(3) = plot3(CABS.R_ECI(1), CABS.R_ECI(2), CABS.R_ECI(3), '.', 'MarkerSize', 10, 'Color', 'b'); % Chaser R
r(4) = plot3(hold5on_R_CABS(:, 1), hold5on_R_CABS(:, 2), hold5on_R_CABS(:, 3), '-.', 'Color', 'b'); % chaser orbit
r(5) = plot3(LES_14(1), LES_14(2), LES_14(3), '.', 'MarkerSize', 10, 'Color', 'r'); % Target R
r(6) = plot3(CABS_14(1), CABS_14(2), CABS_14(3), '.', 'MarkerSize', 10, 'Color', 'b'); % Chaser R
r(7) = plot3(LES_12(1), LES_12(2), LES_12(3), '.', 'MarkerSize', 10, 'Color', 'r'); % Target R
r(8) = plot3(CABS_12(1), CABS_12(2), CABS_12(3), '.', 'MarkerSize', 10, 'Color', 'b'); % Chaser R
r(9) = plot3(LES_34(1), LES_34(2), LES_34(3), '.', 'MarkerSize', 10, 'Color', 'r'); % Target R
r(10) = plot3(CABS_34(1), CABS_34(2), CABS_34(3), '.', 'MarkerSize', 10, 'Color', 'b'); % Chaser R
run('plotEarth');
axis equal
xlabel('X ECI [km]')
ylabel('Y ECI [km]')
zlabel('Z ECI [km]')
title('Hold 5: Football Trajectory -- ECI')
zlim([-2e4 2e4])
legend('LES Position', 'LES Orbit', 'CABS Position', 'CABS Orbit')
grid on

% update time
[t_mission] = missiontime(t_mission, dt_hold5 + dt_remain);
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

[t_man5, out_man5] = Vbar(downrange, vc, LES_orbit.P, dt);
% assign outputs
man5_R = out_man5(:,1:3);
dt_man5 = t_man5(end); % maneuver 1 duration [s]

% --- ECI CALCULATIONS --
% define rotation
C_LVLH2ECI = LVLH2ECI(LES.R_ECI, LES.V_ECI);

% --- DELTA V / PROPOGATE CALCULATIONS ---
% define velocity to get onto hold
deltav_man5 = [0; vc; 0]; % LVLH velocity [km/s]
deltav_man5_ECI = C_LVLH2ECI * deltav_man5; %[km/s]
CABS.V_ECI = CABS.V_ECI + deltav_man5_ECI; %[km/s]

% disp delta v
deltav_tot = deltav_tot + norm(deltav_man5);
disp("Maneuver delta v (ECI) [m/s]: ")
disp(1000*deltav_man5_ECI)
disp("Total Manuever delta v [m/s]: " + 1000*norm(deltav_man5_ECI))
disp("Total Mission delta v Expenditure [m/s]: " + 1000*deltav_tot)


% propogate target
y0_man5_LES = [LES.R_ECI; LES.V_ECI];
[~, LES.R_ECI, LES.V_ECI, man5_R_LES, man5_V_LES] = propogate(dt_man5 + .3, y0_man5_LES, options, mu_Earth);

% propogate chaser
y0_man5_CABS = [CABS.R_ECI; CABS.V_ECI];
[~, CABS.R_ECI, CABS.V_ECI, man5_R_CABS, man5_V_CABS] = propogate(dt_man5, y0_man5_CABS, options, mu_Earth);

% --- PLOT ---
figure()
r(1) = plot3(LES.R_ECI(1), LES.R_ECI(2), LES.R_ECI(3), '.', 'MarkerSize', 10, 'Color', 'r'); % Target R
hold on
r(2) = plot3(man5_R_LES(:, 1), man5_R_LES(:, 2), man5_R_LES(:, 3), '-.', 'Color', 'r'); % target orbit
r(3) = plot3(CABS.R_ECI(1), CABS.R_ECI(2), CABS.R_ECI(3), '.', 'MarkerSize', 10, 'Color', 'b'); % Chaser R
r(4) = plot3(man5_R_CABS(:,1), man5_R_CABS(:,2), man5_R_CABS(:,3), '-.', 'Color', 'b'); % chaser orbit
run('plotEarth');
axis equal
xlabel('X ECI [km]')
ylabel('Y ECI [km]')
zlabel('Z ECI [km]')
title('Maneuver 5: Vbar Approach -- ECI')
zlim([-2e4 2e4])
xlim([-2e4 2e4])
legend('LES Position', 'LES Orbit', 'CABS Position', 'CABS Orbit')
grid on

% update time
[t_mission] = missiontime(t_mission, dt_man5);
disp("--------------------------------------------------------------------")
%% ===== RESULTS =====

disp("--------------------------------------------------------------------")
disp("     ===     RESULTS     ===     ")
disp(" ")
disp("total delta v [m/s] = " + 1000*deltav_tot)

%% PLOTS
% man(num)_R = maneuver states
% hold(num)_R = hold states
% **uncomment to plot**

% --- LVLH PLOTS ---
% Maneuver and Hold plots
% plotLVLH(man1_R, man2_R, man3_R, man4_R, man5_R, hold2_R, hold5_R)

% hold 1 relative velocity plot

% --- ECI PLOTS ---
