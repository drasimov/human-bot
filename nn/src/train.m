function [a, z, w, b] = train(a, z, y, w, b, r)
    for i = 1:length(b)
        [a{i+1}, z{i+1}] = feedforward(w{i}, b{i}, a{i});
    end

    [dw, db] = backprop(a, z, y, w, b);
    
    for i = 1:length(b)
        b{i} = b{i}-r.*db{i};
        w{i} = w{i}-r.*dw{i};
    end
end