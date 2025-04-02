function showLetter(n, arr, d)
    imshow(reshape(arr(n,27:end),d,d), 'InitialMagnification',200)
    xlabel(char(find(arr(n,1:26))+64), 'FontSize', 18)
end