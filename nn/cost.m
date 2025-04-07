function c = cost(x,y,type,derivative,w)
    if derivative
        switch type
            case "quadratic"
                c = x-y;
            case "cross-entropy"
                c = act(x, "sigmoid", false)-y;
        end
    else
        switch type
            case "quadratic"
                c = sum((x-y).^2)/2;
            case "cross-entropy"
                c = -sum(y.*log(x) + (1-y).*log(1-x));
        end
    end
end