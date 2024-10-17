% Cruise Phase Rho Comparison
function [t, A_states, B_states, rho] = rhoComparison(rho_0, rho_f, AR, AV, BR, BV, mu)
% This function uses UV to for Maneuver 1 and Hold 1 to find phase
% duration in seconds

% INPUT:

% OUTPUT:


% define UV sizing
dt = 1; % size of time step [s]
t = 1; % initialize [s]
ind = 1; % index

% initialize
A_states = [];
B_states = [];
rho = norm(rho_0); % set current rho

% step into UV until desired rho met
while rho(ind) > norm(rho_f)
    [AR, AV] = UV(AR, AV, dt, mu);  % Target UV
    [BR, BV] = UV(BR, BV, dt, mu);% Chaser UV
    
    A_states(1:3, ind) = AR;   % assign Target xyz positions
    A_states(4:6, ind) = AV;   % assign Target xyz velocity

    B_states(1:3, ind) = BR; % assign Chaser xyz positions
    B_states(4:6, ind) = BV; % assign Chaser xyz velocity
    
    % calculate relative distance
    rho = [rho, norm(BR - AR)];
    
    % increment
    ind = ind + 1;
    t = [t, ind * dt];
end
