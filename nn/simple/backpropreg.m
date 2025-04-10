for epoch = 1:num_epoch % for each epoch, train and test the network
    order = randperm(n); % determine random order of training digits
    for k = 1:n/m % for each minibatch, train the network
        
        % order training digits according to the random order
        for i = 1:m
            a0(:,i) = X(:,order(i+(k-1)*m));
            y(:,i) = Y(:,order(i+(k-1)*m));
        end
        
        % feed the minibatch through the neural network
        % a2 is the neural network final output
        z1 = w1*a0 + b1*ones(1,m);
        a1 = sig(z1);
        z2 = w2*a1 + b2*ones(1,m);
        a2 = sig(z2);
        
        % find the difference (error) between the neural network output
        % and the true output
        d2 = a2-y;
        d1 = (w2'*d2).*a1.*(1-a1);
        
        % update the weights according to the Gradient Descent Method
        w1 = (1-eta(epoch)*lam/nw)*w1 - eta(epoch)*d1*a0'/m;
        w2 = (1-eta(epoch)*lam/nw)*w2 - eta(epoch)*d2*a1'/m;
        b1 = b1 - eta(epoch)*d1*ones(m,1)/m;
        b2 = b2 - eta(epoch)*d2*ones(m,1)/m;
    end

    % test the neural network
    t1 = sig(w1*XTEST+b1*ones(1,t));
    t2 = sig(w2*t1+b2*ones(1,t));
    R = 0;
    % determine how many digits the neural network got correct
    for i = 1:t
        yt(:,i) = (t2(:,i)-max(t2(:,i)))>=0;
        if norm(yt(:,i)-YTEST(:,i),inf) < 1
            R = R + 1;
        end
    end
    
    % print results of completing a round of training and testing
    fprintf('Epoch %d, %.2f%%, %f\n',epoch,100*R/t,norm(t2-YTEST));
    test_result(epoch) = R/t;
    
    % test the neural network with the same digits it used for training
    tr1 = sigmoid(w1*X+b1*ones(1,n));
    tr2 = sigmoid(w2*tr1+b2*ones(1,n));
    R = 0;
    for i = 1:n
        ytr(:,i) = (tr2(:,i)-max(tr2(:,i)))>=0;
        if norm(ytr(:,i)-Y(:,i),inf) < 1
            R = R + 1;
        end
    end
    train_result(epoch) = R/n;
end

% plot results
close(figure(1))
han = figure(1);
plot(1:num_epoch,train_result,'b');hold on;
plot(1:num_epoch,test_result,'r');hold on;
legend('train','test','Location','SouthEast');
xlabel('epoch');

% save figure
saveas(han,strcat('fig/lam',num2str(lam),'h',num2str(h),'epoch',num2str(num_epoch),'.fig'));

% close(figure(2))
% figure(2)
%     for i = 1:t
%         yt(:,i) = (t2(:,i)-max(t2(:,i)))>=0;
%         if norm(yt(:,i)-YTEST(:,i),inf) >= 1
%             imshow(S(XTEST(:,i)));
%             [YTEST(:,i) t2(:,i)]
%             pause
%         end
%     end