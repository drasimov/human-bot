function [a, z, w, b] = epoch(a, z, data, w, b, r)
    for n = 1:size(data,1)
        a{1} = data(n,27:end)';
        z{1} = data(n,27:end)';
        
        [a, z, w, b] = train(a, z, data(n,1:26)', w, b, r);
    end
end
