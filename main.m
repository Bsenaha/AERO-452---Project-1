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
altitude_difference = 20; % altitude difference between target and chaser orbits [km]
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
rho_f = 35; % rho at end of maneuver [km]

% define UV sizing
dt = 1; % size of time step [s]
t = 1; % initialize [s]
ind = 1; % index

% initialize
OPS_R_man1 = [];
CABS_R_man1 = [];
rho = norm(rho_LVLH); % set current rho

% step into UV until desired rho met
while rho(ind) > norm(rho_f)
    [OPS.R_ECI, OPS.V_ECI] = UV(OPS.R_ECI, OPS.V_ECI, dt, mu_Earth);    % Target UV
    [CABS.R_ECI, CABS.V_ECI] = UV(CABS.R_ECI, CABS.V_ECI, dt, mu_Earth);% Chaser UV
    
    OPS_R_man1(1:3, ind) = OPS.R_ECI;   % assign Target xyz positions for plotting
    CABS_R_man1(1:3, ind) = CABS.R_ECI; % assign Chaser xyz positions for plotting
    
    % calculate relative distance
    rho = [rho, norm(CABS.R_ECI - OPS.R_ECI)];
    
    % increment
    ind = ind + 1;
    t = [t, ind * dt];
end

% find maneuver duration
t_man1 = t(end); % duration of maneuver 1 [s]
disp("MANEUVER 1 DURATION: " + t_man1 / 3600 + " hrs")

% plots
figure()
hrs = t./3600;
plot(hrs, rho)
grid minor

figure()
plot3(OPS_R_man1(1,:), OPS_R_man1(2,:), OPS_R_man1(3,:))
hold on
plot3(OPS_R_man1(1,1), OPS_R_man1(2,1), OPS_R_man1(3,1), 'o')
plot3(CABS_R_man1(1,:), CABS_R_man1(2,:), CABS_R_man1(3,:))
plot3(CABS_R_man1(1,1), CABS_R_man1(2,1), CABS_R_man1(3,1), 'o')
grid minor

disp(" ")
%% ===== HOLD 1 =====

disp("===== HOLD 1 =====")

% * Hold/Cruise from 35km to 25km *
% Use UV to find maneuver duration
rho_f = 35; % rho at end of maneuver [km]

% define UV sizing
dt = 1; % size of time step [s]
t = 1; % initialize [s]
ind = 1; % index

% initialize
OPS_R_man1 = [];
CABS_R_man1 = [];
rho = norm(rho_LVLH); % set current rho

% step into UV until desired rho met
while rho(ind) > norm(rho_f)
    [OPS.R_ECI, OPS.V_ECI] = UV(OPS.R_ECI, OPS.V_ECI, dt, mu_Earth);    % Target UV
    [CABS.R_ECI, CABS.V_ECI] = UV(CABS.R_ECI, CABS.V_ECI, dt, mu_Earth);% Chaser UV
    
    OPS_R_man1(1:3, ind) = OPS.R_ECI;   % assign Target xyz positions for plotting
    CABS_R_man1(1:3, ind) = CABS.R_ECI; % assign Chaser xyz positions for plotting
    
    % calculate relative distance
    rho = [rho, norm(CABS.R_ECI - OPS.R_ECI)];
    
    % increment
    ind = ind + 1;
    t = [t, ind * dt];
end

% find maneuver duration
t_man2 = t(end); % duration of maneuver 1 [s]
disp("MANEUVER 2 DURATION: " + t_man2 / 3600 + " hrs")


% * Additional holding? *

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
