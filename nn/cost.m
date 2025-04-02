function c = cost(y,x)
    c = sum((x-y).^2)/2;
    % c = -sum(y.*log(x) + (1-y).*log(1-x));
end