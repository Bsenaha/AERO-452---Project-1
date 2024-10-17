% Universal Variables
function [rf, vf] = UV(r, v, dt, mu)
    % INPUTS:
    % r = position vector [km]
    % v = velocity vector [km/s]
    % dt = change in time [s]
    % mu [km3/s2]
    
    % OUTPUTS:
    % rf = position vector after dt [km]
    % vf = velocity vector after dt [km/s]
    
    vmag = norm(v); % [km/s]
    rmag = norm(r); % [km]
    
    Energy = .5*(vmag^2)-mu/rmag; % km2/s2
    sqrtmu = sqrt(mu); % saving the sqrt(mu) as a variable to save computational cost
    a = -mu/(2*Energy); % km, Semimajor axis
    
    % setting initial index
    ind = 1;
    % setting initial X guess
    X(ind) = sqrtmu*dt/a;
    
    % Applying newton's method to get second X value
    % allocating a variable for X(n)^2 to save computational cost
    X2 = (X(ind))^2; 
    z = X2/a;
    [C,S] = stumpff(z);
    eq1 = sqrtmu*dt-X2*S-dot(r,v)/sqrtmu*X2*C-rmag*X(ind)*(1-z*S); % f
    eq2 = X2*C+dot(r,v)/sqrtmu*X(ind)*(1-z*S)+rmag*(1-z*C); % f'
    X(ind+1) = X(ind) + eq1/eq2;
    % Incrementing the index by 1
    ind = ind+1;
    
    % Iterating through newton's method until X is within desired tolerance
    while abs(X(ind)-X(ind-1)) > 10^-8
        % Checking to see if the number of iterations is too large
        if ind > 100000
            err('Method does not appear to converge.Check Your Inputs')
        end
        % allocating a variable for X(n)^2 to save computational cost
        X2 = (X(ind))^2; 
        % Calculating X_n+1 value
        z = X2/a;
        [C,S] = stumpff(z);
        eq1 = sqrtmu*dt-X2*S-dot(r,v)/sqrtmu*X2*C-rmag*X(ind)*(1-z*S);
        eq2 = X2*C+dot(r,v)/sqrtmu*X(ind)*(1-z*S)+rmag*(1-z*C);
        X(ind+1) = X(ind) + eq1/eq2;
        % incrementing index
        ind = ind+1;
    end
    % Getting z and C(z)/S(z) values for final X
    z = (X(end)^2)/a;
    [C,S] = stumpff(z);
    
    % Finding universal variables
    f = 1 - (X(end)^2)*C/rmag;
    g = dt - 1/sqrtmu*(X(end)^3)*S;
    rval = (X(end)^2)*C+dot(r,v)/sqrtmu*X(end)*(1-z*S)+rmag*(1-z*C);
    df = sqrtmu/(rmag*rval)*X(end)*(z*S-1);
    dg = 1 - (X(end)^2)/rval*C;
    
    % calculating final position/velocity vectors
    rf = f*r+g*v;
    vf = df*r+dg*v;
end