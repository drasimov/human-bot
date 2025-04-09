function [a, z, w, b] = batched_epoch(a, z, data, w, b, r)
    a{1} = data(:,27:end)';
    z{1} = data(:,27:end)';
    
    [a, z, w, b] = train(a, z, data(:,1:26)', w, b, r);
end
