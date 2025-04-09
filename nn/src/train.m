function [a, z, w, b] = train(a, z, y, w, b, r)
    [a,z] = feedforward(w,b,a,z);
    [dw, db] = backprop(a, z, y, w, b);
    for i = 1:length(b)
        b{i} = b{i}-r.*db{i};
        w{i} = w{i}-r.*dw{i};
    end
end