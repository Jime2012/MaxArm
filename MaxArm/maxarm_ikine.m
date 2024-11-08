function [q] = maxarm_ikine(Td)
    qmotors = fabricante_ikine(Td(1:3,4));
    angles = rotm2eul(Td(1:3,1:3),'zyx');
    q4 = -(angles(1)-deg2rad(qmotors(1)))
    q = [qmotors,rad2deg(q4)];
 
end
