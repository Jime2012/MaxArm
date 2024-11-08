function maxarm_disconnect(robot)
    write(robot, uint8('EXIT'));
    disp('Disconnected from the MaxArm.');
    evalin('base', ['clear ', inputname(1)]);
end