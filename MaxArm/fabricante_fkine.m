function [pos] = fabricante_fkine(q)
    L0 = 84.4;
    L1 = 8.14;
    a2 = 128.4;
    a3 = 138;
    a4 = 16.8;
    
    q_motors = deg2rad(q);

    q_motors(1) = q_motors(1) + (150 * (pi() / 180));
    if (q_motors(1) > (2 * pi()))
        q_motors(1) = q_motors(1) - (2 * pi());
    end
    beta = q_motors(2) - q_motors(3);
    s = sqrt(a2^2 + a3^2 - (2 * a2 * a3 * cos(beta)));
    cos_gamma = ((s^2 + a2^2) - a3^2) / (2 * s * a2);
    if cos_gamma > 1.0
        cos_gamma = 1.0;
    end
    gamma = acos(cos_gamma);
    gamma_alpha = pi() - q_motors(2);
    alpha = gamma_alpha - gamma;
    mu = alpha-beta+pi()/2;

    z = s * sin(alpha);
    r = sqrt(s^2 - z^2);
    r = r  +L1 +a4;
    z = z + L0;
    x = r * cos(q_motors(1));
    y = r * sin(q_motors(1));
    x = -x;
    
    pos = [x,y,z]
end

