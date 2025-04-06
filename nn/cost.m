function c = cost(x,y,type,derivative,w)
    global lambda;
    global N_TRAIN;
    sum_weight = 0;
    for i = 1:length(w)
        sum_weight = sum_weight + sum(w{i}.^2,"all");
    end
    if derivative
        switch type
            case "quadratic"
                c = x-y;
            case "cross-entropy"
                c = -y./x + (1-y)./(1-x);
        end
    else
        switch type
            case "quadratic"
                c = sum((x-y).^2)/2;
            case "cross-entropy"
                c = -sum(x.*log(y) + (1-x).*log(1-y));
        end
        c = c + lambda/(2*N_TRAIN)*sum_weight;
    end
end