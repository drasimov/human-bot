function batches = find_ordered_batches(data, num_batches)
    n = size(data,1);
        batches = cell(1, num_batches);
        % data = data(randperm(n),:);
        for j = 1:num_batches
            rand_j = randi([1, 180]);
            batches{1,j} = data(rand_j:180:n,:);
        end
end
