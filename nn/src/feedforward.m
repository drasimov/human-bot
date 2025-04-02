function [a_new, z] = act(w,b,a_prev)
    z = w*a_prev+b;
    a_new = act(z,"sigmoid",false);
end