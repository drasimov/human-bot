function SHIFTDATA = SHIFTDATA(D_SIZE,TRAIN)

for j = D_SIZE:1
     for i = 1:D_SIZE
           TRAIN(:,D_SIZE*j-i) = TRAIN(:,D_SIZE*j-i+1);
     end
end

for j = 0:D_SIZE-1
    TRAIN(:,D_SIZE*j+1) = 0;
end

SHIFTDATA = TRAIN;
%for one letter