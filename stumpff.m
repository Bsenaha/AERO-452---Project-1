% Stumpff (for UV)
function [C,S] = stumpff(z)
    % Takes in z value and outputs C(z) and S(z) using series expansion
    % Inputs: z = X^2/a
    % Outputs:
    % C = C(z)
    % S = S(z)
    
    
    % Preallocating factorials to save computational cost
    fac1 = [2,24,720,40320,3628800,479001600,8.71782912e+10,...
        2.0922789888e+13,6.402373705728e+15,2.432902008176640e+18];
    fac2 = [6,120,5040,362880,39916800,6.2270208e+09,1.307674368e+12...
        3.55687428096e+14,1.216451004088320e+17,5.109094217170944e+19];
    Rahh = zeros(1,10);
    Rahh(1) = ((-1)^0)*(z).^0;
    % getting terms of series
    for k = 1:9
        Rahh(k+1) = ((-1)^k)*(z).^k;
    end
    % dividing terms of series by factorials and summing terms for C and S
    C = sum(Rahh./fac1);
    S = sum(Rahh./fac2);

end