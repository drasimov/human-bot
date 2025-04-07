function [a, z] = feedforward(w,b,a,z)
    global T_ACT;
    global T_ACTFINAL;

    for i = 1:length(b)-1
        z{i+1} = w{i}*a{i}+b{i};
        a{i+1} = act(z{i+1},T_ACT,false);
    end
    z{length(b)+1} = w{length(b)}*a{length(b)}+b{length(b)};
    a{length(b)+1} = act(z{length(b)+1},T_ACTFINAL,false);
    
end