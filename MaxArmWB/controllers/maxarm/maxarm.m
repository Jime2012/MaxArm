function maxarm

% Inicializar el robot
wb_robot_init;

% Obtener el handle del motor de la joint 'giro_z'
joint = wb_robot_get_device('joint');
joint2 = wb_robot_get_device('joint2');
joint3 = wb_robot_get_device('joint3');
joint4 = wb_robot_get_device('joint4');

% Obtener angulos de cinematica inversa
L0 = 84.4;
L1 = 8.14;
a2 = 128.4;
a3 = 138;
a4 = 16.8;
pos = [-91,-149,150];
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
r = sqrt(x^2 + y^2) - L1 - a4;
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

q_motors = deg2rad([angle1 angle2 angle3]);
q_motors(1) = q_motors(1) + (150 * (pi() / 180));
if (q_motors(1) > (2 * pi()))
    q_motors(1) = q_motors(1) - (2 * pi());
end
q1 = -q_motors(1)-pi()/2; 
q2 = pi()/2-q_motors(2);
q3 = pi()/2-q_motors(2)+q_motors(3);
q4 = q_motors(3);
q0 = [q1,q2,q3,q4,0]
q0 = deg2rad([28.3 53.9 56.0 2.1 120.0])

% Definir el paso de tiempo
TIME_STEP = 1000;

% Bucle principal
while wb_robot_step(TIME_STEP) ~= -1

    % Aplicar la posición deseada a la articulación 1


    wb_motor_set_position(joint2, q0(2));
    wb_motor_set_position(joint3, q0(3));
    wb_motor_set_position(joint4, q0(4));
    wb_motor_set_position(joint, q0(1));
    drawnow;

end

% Código de limpieza: guardar datos en archivos, etc.

end
