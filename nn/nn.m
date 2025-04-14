clear
rng("default")
addpath('src/');

% ----- set network parameters -----
D_SIZE = 8;
N_SETS = 200;
N_CELLS = [D_SIZE.^2, 200, 26];
N_LAYERS = length(N_CELLS);
N_EPOCHS = 300;
R_LEARNINIT = .01;
R_LEARN = R_LEARNINIT;
R_LEARNDEP = .995;
N_BATCHES = 200;
BATCH_SIZE = 1;

% valid options: sigmoid, softmax, relu
global T_ACT;
T_ACT = "sigmoid";
global T_ACTFINAL;
T_ACTFINAL = "sigmoid";

% valid options: quadratic, cross-entropy
global T_COST;
T_COST = "cross-entropy";

% set regularization parameter
global lambda;
lambda = 5;

% state any other tricks (e.g. regularization
NOTES = "Softmax/Quad/Regularization w/ parameter:" + lambda;

%% ----------- read data ------------
tic
ABCDEF = letters("ABCDEF.csv", 'ABCDEF', N_SETS);
GHIJK = letters("GHIJK.csv", 'GHIJK', N_SETS);
LMNOP = letters("LMNOP.csv", 'LMNOP', N_SETS);
QRSTU = letters("QRSTU.csv", 'QRSTU', N_SETS);
VWXYZ = letters("VWXYZ.csv", 'VWXYZ', N_SETS);
DATA = [ABCDEF; GHIJK; LMNOP; QRSTU; VWXYZ];
DATA = sortrows(DATA, 1:26, 'descend');

DATA_S = zeros(26*N_SETS,26+D_SIZE^2);
DATA_S(:,1:26) = DATA(:,1:26);
for n = 1:N_SETS*26
    vec = reshape(DATA(n,27:14426),[120,120]);
    for i = 0:D_SIZE-1
        for j = 1:D_SIZE
            ix = 120/D_SIZE*i+1;
            iy = 120/D_SIZE*(j-1)+1;
            DATA_S(n,26+D_SIZE*i+j) = mean(mean(vec(ix:ix+120/D_SIZE-1,iy:iy+120/D_SIZE-1)));
        end
    end
end

TRAIN = zeros(0.9*N_SETS*26,D_SIZE^2+26);
TEST = zeros(0.1*N_SETS*26,D_SIZE^2+26);

for i = 1:26
    for j = 1:N_SETS
        if j <= 180
            TRAIN((i-1)*180+j,:) = DATA_S((i-1)*200+j,:);
        else
            TEST((i-1)*20+(j-180),:) = DATA_S((i-1)*200+j,:);
        end
    end
end
TRAIN = TRAIN(randperm(size(TRAIN, 1)), :);
SHIFTDATA = SHIFTDATA(D_SIZE,TRAIN);
TRAIN = [TRAIN; SHIFTDATA];
global N_TRAIN;
N_TRAIN = length(TRAIN);


fprintf('Read and processed %i sets of letters in %3 .2fs\n', N_SETS, toc)

%% -------- initialization ----------
tic

TRAIN_BATCHES = find_batches(TRAIN, BATCH_SIZE, N_BATCHES);

b = cell(1,N_LAYERS-1);
w = cell(1,N_LAYERS-1);
a = cell(1,N_LAYERS);
z = cell(1,N_LAYERS);

for i = 2:N_LAYERS
    n_in = N_CELLS(i-1);
    scale = 1/sqrt(n_in + 1);
    b{i-1} = randn(N_CELLS(i),1);
    w{i-1} = randn(N_CELLS(i),N_CELLS(i-1))*scale;
end

fprintf('Initialized network in %3.2fs, layers shown below:\n', toc)
fprintf('%i neurons\n', N_CELLS)

%% ------- backprop and gd ---------
tic

x = 0:N_EPOCHS;
ycost = zeros(1,N_EPOCHS+1);
ytrain = zeros(1,N_EPOCHS+1);
ytest = zeros(1,N_EPOCHS+1);

[ycost(1), ytrain(1), ytest(1)] = testnetwork(a, z, TEST, TRAIN, w, b);
fprintf('Calculated random cost in %3.2fs, C = %3.6f, %3.2f%%, %3.2f%%\n', toc, ycost(1), ytrain(1)*100, ytest(1)*100);

for e = 1:N_EPOCHS
    tic
    for n = 1:N_BATCHES
        T_BATCH = TRAIN_BATCHES{1,n};
        [a, z, w, b] = batched_epoch(a, z, T_BATCH, w, b, R_LEARN);
    end
    [ycost(e+1), ytrain(e+1), ytest(e+1)] = testnetwork(a, z, TEST, TRAIN, w, b);
    fprintf('Training epoch %i took %3.2fs, C = %3.6f, %3.2f%%, %3.2f%%\n', e, toc, ycost(e+1), ytrain(e+1)*100, ytest(e+1)*100)
    TRAIN_BATCHES = find_batches(TRAIN, BATCH_SIZE, N_BATCHES);
    R_LEARN = R_LEARNDEP*R_LEARN;
end

%% --------- testing -----------
clf
hold on
plot(x, ytrain)
plot(x, ytest)
title(strcat("Model Accuracy (",num2str(D_SIZE),"x",num2str(D_SIZE)," ",mat2str(N_CELLS)," ",num2str(R_LEARNINIT),"*",num2str(R_LEARNDEP)," ",T_ACT,T_ACTFINAL,"/",T_COST,"/",NOTES,")"))
legend('Train','Test','Location','SouthEast');
pause

%% -- make fun of the network? --
%for n = 1:size(TRAIN,1)
%    z{1} = TRAIN(n,27:end)';
%    a{1} = TRAIN(n,27:end)';
%    for i = 1:(length(a)-1)
%        [a{i+1}, z{i+1}] = feedforward(w{i}, b{i}, a{i});
%    end

%    [V, I] = max(a{length(a)});
%    if I ~= find(TRAIN(n,1:26))
%        showLetter(n,TRAIN,D_SIZE);
%        fprintf('Network thought a %c was a %c\n', char(find(TRAIN(n,1:26))+64), char(I+64))
%        pause
%    end
%end

