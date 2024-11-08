function robot = maxarm_connect(number)
    robot = [];
    if (number == 1)
        ip = '192.168.50.140';
        %ip = '192.168.0.11'; 
        port = 8116;
    end
    try
        robot = tcpclient(ip, port);
    catch
        disp('ERROR: Could not connect to the MaxArm.');
    end
end