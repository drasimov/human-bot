function [c, atrain, atest] = testnetwork(a, z, test, train, w, b);
    global T_COST;
    c = 0;
    for n = 1:size(train,1)
        z{1} = train(n,27:end)';
        a{1} = train(n,27:end)';
<<<<<<< HEAD
        for i = 1:(length(a)-1)
            [a{i+1}, z{i+1}] = feedforward(w{i}, b{i}, a{i});
        end
        c = c + cost(train(n,1:26)', a{length(a)},T_COST,false,w);
=======
        [a,z] = feedforward(w,b,a,z);
        c = c + cost(a{length(a)},train(n,1:26)',T_COST,false);
>>>>>>> 4020a011378051796926d420729d981970af60c6
    end
    c = c/size(train,1);

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