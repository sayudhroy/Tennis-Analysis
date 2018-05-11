function D = GetDistances(playerLocations)
    len = size(playerLocations, 1);
    D = 0;
    for i = 2:len
        pos = [playerLocations(i-1, 1), playerLocations(i-1, 2); ...
               playerLocations(i, 1), playerLocations(i, 2)];
        distance = pdist(pos, 'euclidean');
        D = D + distance;
    end
    D = D * 0.2;
end