function locations = GetPlayerLocations(bboxes)
len = size(bboxes, 1);
locations = zeros(len, 2);
for i = 1:len
    hgt = bboxes(i, 4) * 0.85;
    wid = bboxes(i, 3) * 0.5;
    locations(i, 1) = bboxes(i, 1) + wid;
    locations(i, 2) = bboxes(i, 2) + hgt;
end
end