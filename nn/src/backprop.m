function [dw, db] = backprop(a, z, y, w, b)
    global T_ACT;
    global T_ACTFINAL;
    global T_COST;
    global lambda;
    global N_TRAIN;
    n = length(a);

    l = cell(1,n);
    dw = cell(1,n-1);
    db = cell(1,n-1);

<<<<<<< HEAD
    % l{n} = a{n}>0.*dcost(a{n},y).*1./a{n}.*a{n}; %BP1
    l{n} = cost(a{n},y,T_COST,true,w).*act(a{n},T_ACT,true); %BP1
    dw{n-1} = l{n}*a{n-1}' + (lambda/N_TRAIN) * w{n-1};
    db{n-1} = l{n};
    for i = flip(2:n-1)
        l{i} = (w{i}'*l{i+1}).*(a{i}.*(1-a{i})); %BP2
        dw{i-1} = l{i}*a{i-1}' + (lambda/N_TRAIN) * w{i-1}; %BP3
=======
    l{n} = cost(a{n},y,T_COST,true).*act(a{n},T_ACTFINAL,true); %BP1
    dw{n-1} = l{n}*a{n-1}';
    db{n-1} = l{n};
    for i = flip(2:n-1)
        l{i} = (w{i}'*l{i+1}).*act(a{i},T_ACT,true); %BP2
        dw{i-1} = l{i}*a{i-1}'; %BP3
>>>>>>> 4020a011378051796926d420729d981970af60c6
        db{i-1} = l{i}; %BP4
    end
end