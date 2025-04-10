clear all
addpath('simple/');
m = 4; % number of batches per epoch
num_epoch = 300;
eta_start = 0.005;
eta_end = 0.001;
eta = linspace(eta_start,eta_end,num_epoch); % learning rate

input = 8*8; % input size
h = 600; % number of hidden neurons
o = 26; % output neurons
nw = h*input + o*h; %number of weights
lam = 30; % regulation parameter

sig=@sigmoid;
% sigp=@sigmoidp;

% initialize randomized weights
w1 = (rand(h,input)-0.5)/sqrt(input*h);
w2 = (rand(o, h)-0.5)/sqrt(h*o);
b1 = (rand(h,1)-0.5)/2;
b2 = (rand(o,1)-0.5)/2;

% input training and testing data
% Y and YTEST are the correct answers for the training data and testing
% data, respectively
% X and XTEST are the images for the training data and testing data,
% respectively
input_data;

% time to train the neural network!
backpropreg
%show_incorrect