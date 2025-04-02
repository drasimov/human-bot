function [a_new, z] = act(w,b,a_prev)
    global T_ACT;

    z = w*a_prev+b;
    a_new = act(z,T_ACT,false);
end