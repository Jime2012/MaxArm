function [Tr] =optitrack(data, markerNumber)
    o_T_b = eye(4,4);
    datos_40_origen = [0.0763   -0.0073    0.0352   -3.6077   84.7606 -59.4981];
    %datos_40_origen = [0.0804   -0.0170    0.0346  -10.9060   84.2734  -52.2278]
    o_T_marker40 = transl(datos_40_origen(1)*1000,datos_40_origen(2)*1000,datos_40_origen(3)*1000)...
    *trotx(datos_40_origen(4))*troty(datos_40_origen(5))*trotz(datos_40_origen(6));
    marker40_T_b = ((o_T_marker40)^(-1))*o_T_b;
    datos_40 = robotat_get_pose(data, 40, 'eulxyz');
    O_T_40 = transl(datos_40(1)*1000,datos_40(2)*1000,datos_40(3)*1000)...
    *trotx(datos_40(4))*troty(datos_40(5))*trotz(datos_40(6));
    O_T_B = O_T_40*marker40_T_b;
    
    datos = robotat_get_pose(data, markerNumber, 'eulxyz');
    O_T_markernumber = transl(datos(1)*1000,datos(2)*1000,datos(3)*1000)...
    *trotx(datos(4)-10)*troty(datos(5))*trotz(datos(6));
    Tr = ((O_T_B)^(-1))*O_T_markernumber;

end

