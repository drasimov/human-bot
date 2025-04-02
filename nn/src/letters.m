% e.g: letters("data.csv", 'ABC', N_SET);
function arr = letters(data, set, n)
    raw = readmatrix(data,'Range',[1 2 n*length(set) 14401]);
    arr = [zeros(n*length(set),26) raw];
    for i = 1:length(set)
        arr(i:length(set):n*length(set), set(i)-'0'-16) = 1;
    end
end