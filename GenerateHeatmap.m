function GenerateHeatmap(playerLocations)
court = CreateCourt();
temp = ~court;
temp = cat(3, temp, temp, temp);
temp = double(temp);
gaussiankernel = fspecial('gaussian', [390+160 180+40], 10);
map = zeros(390+160, 180+40);
% map(:) = 255;
X = playerLocations;
X = uint16(X);
len = size(X, 1);
for i = 1:len
    pos_x = X(i, 1);
    pos_y = X(i, 2);
    map(pos_y, pos_x) = 255;
end
imshow(temp);
hold on
density = imfilter(map, gaussiankernel, 'replicate');
OverlayImage = imshow(density);
caxis auto  
colormap(OverlayImage.Parent, jet);
colorbar(OverlayImage.Parent);
set( OverlayImage, 'AlphaData', 0.8);
end
