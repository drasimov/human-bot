function [c, atrain, atest] = testnetwork(a, z, test, train, w, b);
    global T_COST;

    c = 0;
    for n = 1:size(train,1)
        z{1} = train(n,27:end)';
        a{1} = train(n,27:end)';
        [a,z] = feedforward(w,b,a,z);
        c = c + cost(a{length(a)},train(n,1:26)',T_COST,false);
    end
    c = sum(c)/size(train,1)/length(c);

    atest = 0;
    for n = 1:size(test,1)
        z{1} = test(n,27:end)';
        a{1} = test(n,27:end)';
        [a, z] = feedforward(w,b,a,z);
    
        [V, I] = max(a{length(a)});
        if I == find(test(n,1:26));
            atest = atest + 1;
        end
    end
    atest = atest/size(test,1);

    atrain = 0;
    for n = 1:size(train,1)
        z{1} = train(n,27:end)';
        a{1} = train(n,27:end)';
        [a, z] = feedforward(w,b,a,z);
    
        [V, I] = max(a{length(a)});
        if I == find(train(n,1:26));
            atrain = atrain + 1;
        end
    end
    atrain = atrain/size(train,1);

end