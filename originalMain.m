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

% Get Target RV from COES
[OPS.R_peri, OPS.V_peri] = COES2RV(OPS_orbit.theta, OPS_orbit.rpMag, OPS_orbit.ecc, mu_Earth); % perifocal
% Convert to ECI
C_peri2ECI = peri2ECI(OPS_orbit.omega, OPS_orbit.inc, OPS_orbit.RAAN);
OPS.R_ECI = C_peri2ECI * OPS.R_peri; % ECI [km]
OPS.V_ECI = C_peri2ECI * OPS.V_peri; % ECI [km/s]

% Defining Chaser COES
% All are the same except rp and theta
CABS_orbit = OPS_orbit; % clone target orbit to chaser

% Solving for Chaser initial position (100 km) on lower altitude orbit:
rho_missionstart = 100; %[km]
% reassign chaser rp and true anomaly
altitude_difference = 0; %[km]

CABS_orbit.rpMag = OPS_orbit.rpMag - altitude_difference; % periapse radius of chaser [km]
[CABS.R_peri, CABS_orbit.theta] = PositionSolver(OPS_orbit.theta, OPS_orbit.rpMag, CABS_orbit.rpMag, OPS_orbit.ecc, mu_Earth, rho_missionstart); % perifocal

disp(" ")
%% ===== DEFINING STATES =====

disp("===== DEFINING STATES =====")

% Redefine Target RV
OPS.R_ECI = OPS.R_ECI;
OPS.V_ECI = OPS.V_ECI;

% Define Chaser RV based on previously found rp and theta
[CABS.R_peri, CABS.V_peri] = COES2RV(CABS_orbit.theta, CABS_orbit.rpMag, CABS_orbit.ecc, mu_Earth);
% Convert to ECI
CABS.R_ECI = C_peri2ECI * CABS.R_peri; % ECI [km]
CABS.V_ECI = C_peri2ECI * CABS.V_peri; % ECI [km/s]

% Define initial relative position and velocity
rho_ECI = CABS.R_ECI - OPS.R_ECI; % ECI [km]
OPS_orbit.h_vec = cross(OPS.R_ECI, OPS.V_ECI);
omega = OPS_orbit.h_vec / norm(OPS.R_ECI)^2;
drho_ECI = CABS.V_ECI - OPS.V_ECI - (cross(omega, rho_ECI)); % ECI [km/s]

% Convert from ECI to LVLH
C_ECI2LVLH = ECI2LVLH(OPS.R_ECI, OPS.V_ECI);
rho_LVLH = C_ECI2LVLH * rho_ECI; % rel. position [km]
drho_LVLH = C_ECI2LVLH * drho_ECI; % rel. velocity [km/s]
disp("Initial drho = " + norm(drho_LVLH*1000) + " m/s")
OPS.R_LVLH = C_ECI2LVLH * OPS.R_ECI;

%{
SAMPLE PLOTS for understanding initial orbital relations
y0 = [OPS.R_ECI; OPS.V_ECI];
[t, state] = ode45(@tbsMotion, [0 10000], y0, options, mu_Earth);
y1 = [CABS.R_ECI; CABS.V_ECI];
[t, states] = ode45(@tbsMotion, [0 10000], y1, options, mu_Earth);
% plot orbits
plot3(state(:,1), state(:,2), state(:,3))
hold on
plot3(states(:,1), states(:,2), states(:,3))
grid minor
%}

disp(" ")
%% ===== MANEUVER 1 =====

disp("===== MANEUVER 1 =====")

% * Cruise from 100km to 35 km *

% Use UV to find maneuver duration
% define necessary parameters to call UV solver

rho_f = 40; % rho at end of maneuver [km]
rho_0 = norm(rho_LVLH); % initial/current rho [km]

% call rho comparison to get states between rho values
[t, OPS_states, CABS_states, rho] = rhoComparison(rho_0, rho_f, OPS.R_ECI, OPS.V_ECI, CABS.R_ECI, CABS.V_ECI, mu_Earth);

% assign state outputs
OPS.R_ECI = OPS_states(1:3, end); % update target position [km]
OPS.V_ECI = OPS_states(4:6, end); % update target velocity [km]
CABS.R_ECI = CABS_states(1:3, end); % update chaser position [km]
CABS.V_ECI = CABS_states(4:6, end); % update chaser velocity [km]

rho_ECI = CABS.R_ECI - OPS.R_ECI; % update rho
% convert to LVLH (and change hold 1 rho)
t_man1 = t(end); % maneuver duration [s]
disp("MANEUVER 1 DURATION: " + t_man1 / 3600 + " hrs")

%{
% plots
figure()
hrs = t./3600;
plot(hrs, rho)
grid minor

figure()
plot3(OPS_states(1,:), OPS_states(2,:), OPS_states(3,:))
hold on
plot3(OPS_states(1,1), OPS_states(2,1), OPS_states(3,1), 'o')
plot3(CABS_states(1,:), CABS_states(2,:), CABS_states(3,:))
plot3(CABS_states(1,1), CABS_states(2,1), CABS_states(3,1), 'o')
grid minor
%}

disp(" ")
%% ===== HOLD 1 =====

disp("===== HOLD 1 =====")

% * Hold/Cruise from 35km to 25km *
% Use UV to find maneuver duration

rho_f = 20; % rho at end of maneuver [km]
rho_0 = norm(rho_ECI); %**change to rho_LVLH once calculated**

% call rho comparison to get states between rho values
[t, OPS_states, CABS_states, rho] = rhoComparison(rho_0, rho_f, OPS.R_ECI, OPS.V_ECI, CABS.R_ECI, CABS.V_ECI, mu_Earth);

% assign state outputs
OPS.R_ECI = OPS_states(1:3, end); % update target position [km]
OPS.V_ECI = OPS_states(4:6, end); % update target velocity [km]
CABS.R_ECI = CABS_states(1:3, end); % update chaser position [km]
CABS.V_ECI = CABS_states(4:6, end); % update chaser velocity [km]

rho_ECI = CABS.R_ECI - OPS.R_ECI; % update
% convert to LVLH (and change hold 1 rho)
t_hold1 = t(end); % maneuver duration [s]
disp("HOLD 1 DURATION: " + t_hold1 / 3600 + " hrs")
disp(" ")

%% * Additional holding? *
%{
disp("Additional Holding??")
% finding the closest we can get on this orbit:

rho_f = altitude_difference + .25; % rho at end of maneuver [km]
rho_0 = norm(rho_ECI); %**change to rho_LVLH once calculated**

% call rho comparison to get states between rho values
[t, OPS_states, CABS_states, rho] = rhoComparison(rho_0, rho_f, OPS.R_ECI, OPS.V_ECI, CABS.R_ECI, CABS.V_ECI, mu_Earth);

% assign state outputs
OPS.R_ECI = OPS_states(1:3, end); % update target position [km]
OPS.V_ECI = OPS_states(4:6, end); % update target velocity [km]
CABS.R_ECI = CABS_states(1:3, end); % update chaser position [km]
CABS.V_ECI = CABS_states(4:6, end); % update chaser velocity [km]

rho_ECI = CABS.R_ECI - OPS.R_ECI; % update
% convert to LVLH
t_hold1add = t(end); % maneuver duration [s]
disp("HOLD 1 (additional) DURATION: " + t_hold1add / 3600 + " hrs")
disp(norm(rho_ECI))
%}

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

% * Vbar Burn from 1km rel. distance to 300m rel. distance *
disp(" ")
%% ===== HOLD 3 =====

disp("===== HOLD 3 =====")

% * Hold @ 300m rel. distance *

disp(" ")
%% ===== MANEUVER 4 =====

disp("===== MANEUVER 4 =====")

% * Vbar Burn from 300m rel. distance to 20m rel. distance *

disp(" ")
%% ===== HOLD 4 (FINAL HOLD) =====

disp("===== HOLD 4 =====")

% * Hold @ 20m rel. distance *

disp(" ")
%% ===== RESULTS =====

disp("===== RESULTS =====")