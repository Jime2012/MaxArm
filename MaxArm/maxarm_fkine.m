function [Td] = maxarm_fkine(q)
pos = fabricante_fkine(q(1:3))
Td = transl(pos(1),pos(2),pos(3))*trotz(q(1)-q(4));
end

