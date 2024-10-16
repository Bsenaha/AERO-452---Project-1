function [Position] = PositionSolver(theta, omega, inc, RAAN, rp, ecc, mu, rho_desired)
% Position Solver
% Solves for desired position (ECI) a certain distance away from target
% ONLY ON SAME ORBIT
% for example, 100 km away ON SAME ORBIT

% INPUT:
% Orbit COEs, desired distance between objects [km]

% OUTPUT:
% Position = ECI R vector of chaser position at specified distance BEHIND 
% target

% define target position (peri)
[R_A, ~] = COES2RV(theta, rp, ecc, mu);
R_B = [];

% define tolerance
tol = 1e-5;

% solver (done in perifocal)
rho = 0;
while norm(rho_desired) - norm(rho) > tol
    % decrease theta slightly
    theta = theta - .0001;

    % calculate COES2RV with new theta
    [R_B, ~] = COES2RV(theta, rp, ecc, mu);

    % calc rho
    rho = R_A - R_B;
end

% convert to ECI
Position = R_B;
