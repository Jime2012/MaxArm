function q0 = motors2joints(q_motors)
    q_motors(1) = q_motors(1) + (150 * (pi() / 180));
    if (q_motors(1) > (2 * pi()))
        q_motors(1) = q_motors(1) - (2 * pi());
    end

    q1 =-q_motors(1)-pi()/2;
    q2 = pi()/2-q_motors(2);
    q3 = pi()/2-q_motors(2)+q_motors(3);
    q4 = q_motors(3);
    q0 = [q1,q2,q3,q4];
end

