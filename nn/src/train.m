function [a, z, w, b] = train(a, z, y, w, b, r)
    global lambda;
    global N_TRAIN;
    [a,z] = feedforward(w,b,a,z);
    [dw, db] = backprop(a, z, y, w, b);
    
    for i = 1:length(b)
        b{i} = b{i}-r.*db{i};
        w{i} = (1-r*lambda/N_TRAIN)*w{i}-r.*dw{i};
    end
end