function dstate = tbsMotion(t, state, mu)
    % eq of motion for a two body system
    
    r = state(1:3);
    v = state(4:6);
    rMag = norm(r);

    dv = -mu*r/rMag^3;

    dstate = [v;dv];
