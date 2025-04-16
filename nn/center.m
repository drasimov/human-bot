function data = center(pix,d)
    orig = reshape(pix,d,d);
    w = (1:d)';
    sx = 4.5 - sum(orig,1)*w/sum(sum(orig,1));
    sy = 4.5 - sum(orig,2)'*w/sum(sum(orig,2));

    orig = [zeros(d) orig zeros(d)];
    data = orig;
    for x=9:16
        if sx > 0
            data(:,x) = (1-mod(sx,1))*orig(:,x-floor(sx)) + mod(sx,1)*orig(:,x-floor(sx)-1);
        else 
            data(:,x) = (1-mod(sx,1))*orig(:,x-ceil(sx)) + mod(sx,1)*orig(:,x-ceil(sx)+1);
        end
    end

    data = [zeros(8); data(:,9:16); zeros(8)];
    orig = data;
    for y=9:16
        if sy > 0
            data(y,:) = (1-mod(sy,1))*orig(y-floor(sy),:) + mod(sy,1)*orig(y-floor(sy)-1,:);
        else 
            data(y,:) = (1-mod(sy,1))*orig(y-ceil(sy),:) + mod(sy,1)*orig(y-ceil(sy)+1,:);
        end
    end

    data = data(9:16,:);
    data = reshape(data,1,64);
end