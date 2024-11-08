function [q] = fabricante_ikine(pos)
    L0 = 84.4;
    L1 = 8.14;
    a2 = 128.4;
    a3 = 138;
    a4 = 16.8;
    
    x = -pos(1);
    y = pos(2);
    z = pos(3);
    theta = 0;

    if x == 0
        if y >= 0
            theta = pi() / 2;
        else
            theta = pi() / 2 * 3;
        end
    else
        if y == 0
            if x > 0
                theta = 0;
            else
                theta = pi();
            end
        else
            if x < 0
                theta = atan(y / x) + pi();
            else
                theta = atan(y / x) + (2 * pi());
            end
        end
    end
    r = sqrt(x^2 + y^2) -L1- a4;
    z = z - L0;
    alpha = atan(z / r);
    beta = acos((a2^2 + a3^2 - (r^2 + z^2)) / (2 * a2 * a3));
    gamma = acos((a2^2 + (r^2 + z^2 - a3^2)) / (2 * a2 * sqrt(r^2 + z^2)));
    theta2 = pi() - (alpha + gamma);
    theta3 = pi() - (alpha + beta + gamma);
    angles = rad2deg(theta);
    if angles <= 30
        angles = angles + 360;
    end
    angle1 = angles - 150;
    angle2 = rad2deg(theta2);
    angle3 = rad2deg(theta3);
    q = [angle1, angle2, angle3];
end

