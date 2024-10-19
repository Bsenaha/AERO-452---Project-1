function [Position, theta_Chaser] = PositionSolver(theta, rp_target, rp_chaser, ecc, mu, rho_desired)
% Position Solver
% Solves for position of chaser (ECI) a specified distance away from target
% on coplanar orbits with different altitudes

% INPUT:
% Target Orbit COEs (+ chaser rp), desired distance between objects [km]

% OUTPUT:
% Position = ECI R vector of chaser position at specified distance BEHIND 
% target [km]

% define target position (peri)
[R_A, ~] = COES2RV(theta, rp_target, ecc, mu);
% define chaser position (peri)
[R_B, ~] = COES2RV(theta, rp_chaser, ecc, mu);
% define distance between
rho = R_A - R_B;

% if already further apart than desired, throw error
if rho > rho_desired
    warning('Object altitudes are incompatible for desired distance')
end

% define the difference between desired distance and actual distance
% this value is what we want to go to zero
rho_difference = norm(rho_desired) - norm(rho); % still perifocal [km]

% define tolerance and step in
tol = 1e-6;
while rho_difference > tol
    % decrease chaser theta slightly
    theta = theta + 1e-8;
    theta_Chaser = theta; % true anomaly of chaser on same orbit [rad]

    % calculate new chaser position with new theta
    [R_B, ~] = COES2RV(theta, rp_chaser, ecc, mu);

    % calc rho
    rho = R_A - R_B;
    % recalculate difference from desired
    rho_difference = norm(rho_desired) - norm(rho); % still perifocal [km]
end

% assign output
Position = R_B; % Chaser position (perifocal) [km]
