function a = act(z, type, derivative)
    if derivative
        switch type
            case "sigmoid"
                a = z.*(1-z);
            case "softmax"
                a = ones(length(z),1);
            case "relu"
                a = z>0;
        end
    else
        switch type
            case "sigmoid"
                a = 1./(1+exp(-z));
            case "softmax"
                a = exp(z)./sum(exp(z));
            case "relu"
                a = max(0,z);
        end
    end
end