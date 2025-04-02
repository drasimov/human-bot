function a = act(z, type, derivative)
    if derivative
        switch type
            case "sigmoid"
                a = z.*(1-z);
            case "softmax"
                a = z;
        end
    else
        switch type
            case "sigmoid"
                a = 1./(1+exp(-z));
            case "softmax"
                a = exp(z)./sum(exp(z));
        end
    end
end