function corners = GetCorners(points)
points = round(points);
% Getting Top Points
min_y = min(points(:,2));
mask = points(:,2) == min_y;

min_x = min(points(mask));
top_left = [min_x, min_y];

max_x = max(points(mask));
top_right = [max_x, min_y];

%Getting Bottom Points
max_y = max(points(:,2));
mask = points(:,2) == max_y;

min_x = min(points(mask));
bottom_left = [min_x, max_y];

max_x = max(points(mask));
bottom_right = [max_x, max_y];

corners = [top_left; bottom_left; bottom_right; top_right];
end