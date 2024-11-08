function maxarm_send(robot,q,pump) 
    if((q(1)>240) &&(q(1)<0))
        error('Joint angle out of range.');
    elseif ((q(2)<-30) &&(q(2)>210))
        error('Joint angle out of range.');
    elseif ((q(3)>120) &&(q(3)<-120))
        error('Joint angle out of range.'); 
    end
    

    value.cfg = q; 
    value.pmp = pump;
    disp(jsonencode(value));
    write(robot,uint8(jsonencode(value)));
end