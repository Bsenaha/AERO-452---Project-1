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

disp(" ")
%% ===== DEFINING STATES =====

disp("===== DEFINING STATES =====")

disp(" ")
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

disp(" ")
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

disp(" ")
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

disp(" ")
%% ===== HOLD 2 =====

disp("===== HOLD 2 =====")

% * Hold @ 1km rel. distance *

disp(" ")
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

disp(" ")
%% ===== HOLD 3 =====

disp("===== HOLD 3 =====")

% * Hold @ 300m rel. distance *

disp(" ")
%% ===== MANEUVER 4 =====

disp("===== MANEUVER 4 =====")
% ** Vbar Hop from 1km to 20m downrange

% --- LVLH CALCULATIONS ---
% define maneuver parameters
downrange = .3; %[km]
y = -0.28; %[km]

% call hop function
[t4, deltav_y4, h4, out4] = hop(downrange, y, OPS_orbit.P);
% assign outputs
man4_R = out4(:,1:3); %[km]

disp(" ")
%% ===== HOLD 4 (FINAL HOLD) =====

disp("===== HOLD 4 =====")

% ** Vbar approach with slight rel. velocity

disp(" ")
%% ===== RESULTS =====

disp("===== RESULTS =====")

%% PLOTS
% man(num)_R = maneuver states
% hold(num)_R = hold states
% **uncomment to plot**

% --- LVLH PLOTS ---

% == maneuver 1 spotlight ==
%{
figure()
m(1) = plot(man1_R(:,2), man1_R(:,1), 'r'); % spotlight maneuver plot
hold on
m(2) = plot(man1_R(1,2), man1_R(1,1), '*', 'Color', 'm'); % maneuver start
m(3) = plot(man1_R(end,2), man1_R(end,1), '*', 'Color', 'b'); % maneuver end
m(4) = plot(hold1_R(:,2), hold1_R(:,1), 'k');
m(5) = plot(man2_R(:,2), man2_R(:,1), 'k');
m(6) = plot(man3_R(:,2), man3_R(:,1), 'k');
m(7) = plot(man4_R(:,2), man4_R(:,1), 'k');
m(8) = scatter(0, 0, 'k', 'filled'); % Target
xlim([-45 105])
ylim([-22 22])
grid minor
title('Maneuver 1: Hop Trajectory -- LVLH')
xlabel('Downrange -- Rbar [km]')
ylabel('Altitude -- Vbar [km]')
legend([m(1) m(2) m(3) m(8)], 'Maneuver 1 Trajectory', 'Start', ...+
    'End', 'Target Position', 'Location', 'Southeast')
%}

% == maneuver 2 spotlight ==
%{
figure()
m(1) = plot(man2_R(:,2), man2_R(:,1), 'r'); % spotlight maneuver plot
hold on
m(2) = plot(man2_R(1,2), man2_R(1,1), '*', 'Color', 'm'); % maneuver start
m(3) = plot(man2_R(end,2), man2_R(end,1), '*', 'Color', 'b'); % maneuver end
m(4) = plot(hold1_R(:,2), hold1_R(:,1), 'k');
m(5) = plot(man1_R(:,2), man1_R(:,1), 'k');
m(6) = plot(man3_R(:,2), man3_R(:,1), 'k');
m(7) = plot(man4_R(:,2), man4_R(:,1), 'k');
m(8) = scatter(0, 0, 'k', 'filled'); % Target
xlim([-45 105])
ylim([-22 22])
grid minor
title('Maneuver 2: Hop Trajectory -- LVLH')
xlabel('Downrange -- Rbar [km]')
ylabel('Altitude -- Vbar [km]')
legend([m(1) m(2) m(3) m(8)], 'Maneuver 2 Trajectory', 'Start', ...+
    'End', 'Target Position', 'Location', 'Southeast')
%}

% == maneuver 3 spotlight ==
%{
figure()
%}

%{
% == maneuver 4 ==
figure()
plot(man4_R(:,2), man4_R(:,1))
%}

%{
% == maneuvers combined (and football) ==
figure()
plot(man1_R(:,2), man1_R(:,1))
hold on
plot(hold1_R(:,2), hold1_R(:,1))
plot(man2_R(:,2), man2_R(:,1))
plot(man3_R(:,2), man3_R(:,1))
plot(man4_R(:,2), man4_R(:,1))
xlim([-45 105])
ylim([-20 20])
grid minor
%}

% == hold 1 spotlight ==
%{
figure()
m(1) = plot(hold1_R(:,2), hold1_R(:,1), 'r'); % spotlight hold plot
hold on
m(2) = plot(hold1_R(1,2), hold1_R(1,1), '*', 'Color', 'm'); % hold start
m(3) = plot(hold1_R(end,2), hold1_R(end,1), '*', 'Color', 'b'); % hold end
m(4) = plot(man1_R(:,2), man1_R(:,1), 'k');
m(5) = plot(man2_R(:,2), man2_R(:,1), 'k');
m(6) = plot(man3_R(:,2), man3_R(:,1), 'k');
m(7) = plot(man4_R(:,2), man4_R(:,1), 'k');
m(8) = scatter(0, 0, 'k', 'filled'); % Target
xlim([-45 105])
ylim([-22 22])
grid minor
title('Maneuver 1: Hop Trajectory -- LVLH')
xlabel('Downrange -- Rbar [km]')
ylabel('Altitude -- Vbar [km]')
legend([m(1) m(2) m(3) m(8)], 'Maneuver 1 Trajectory', 'Start', ...+
    'End', 'Target Position', 'Location', 'Southeast')
%}

%{
% == hold 2 ==

%}

%{
% == hold 3 ==

%}

%{
% == hold 4 ==

%}