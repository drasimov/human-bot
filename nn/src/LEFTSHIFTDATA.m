function LEFTSHIFTDATA = LEFTSHIFTDATA(D_SIZE,TRAIN)

for j = D_SIZE:1
     for i = D_SIZE:2
           TRAIN(:,D_SIZE*j-i) = TRAIN(:,D_SIZE*j-i+1);
     end
end

for j = 1:D_SIZE
    TRAIN(:,D_SIZE*j) = 0;
end

LEFTSHIFTDATA = TRAIN;