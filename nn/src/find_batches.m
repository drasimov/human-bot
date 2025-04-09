function batches = find_batches(data, batchsize, num_batches)
    n = size(data,1);
    batches = cell(1, num_batches);
    data = data(randperm(n),:);
    for j = 1:num_batches
        rand_j = randi([1, n-batchsize]);
        batches{1,j} = data(rand_j+1:rand_j+batchsize,:);
    end
end
