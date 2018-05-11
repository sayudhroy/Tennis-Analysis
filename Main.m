clc;
clear all;
close all;

file = 'Single Point.mp4';
rate = GetFrameRate(file);

peopleDetector = vision.PeopleDetector('ClassificationModel', ...
                    'UprightPeople_96x48', 'MergeDetections', true);
video = vision.VideoFileReader(file);
viewer = vision.VideoPlayer;

frames = [];
playerLocations = [];
playerSpeeds = [];
frameNumber = 0;
local_acc = 0;
acc = 0;
timeElapsed = 0;
max_speed = 0;
timeEnd = 35.5; %End of Rally

court = CreateCourt();
figure(1), imshow(~court), hold on;

se = strel('disk', 2);
while timeElapsed <= timeEnd
    frameNumber = frameNumber + 1;
    im = step(video);
    im = imresize(im, 0.6);
    image = rgb2gray(im);
    image = imtophat(image, se);
    
    bw = edge(image,'canny');
    width = size(im, 1);
    height = size(im, 2);
    
    [H,T,R] = hough(bw);
    P  = houghpeaks(H,10,'threshold',ceil(0.3*max(H(:))));
    lines = houghlines(bw,T,R,P,'FillGap',20,'MinLength',200);
    
    figure(2), imagesc(im);
    max_len = 0;
    len = length(lines);
    points = [];
    for i = 1:len
        xy1 = [lines(i).point1; lines(i).point2];
        for j = i+1:len
            xy2 = [lines(j).point1; lines(j).point2];
            [x, y] = SolveEquations(xy1(:, 1), xy1(:, 2), ...
                                    xy2(:, 1), xy2(:, 2));
            if x>0 && x<=height && y>0 && y<width
                points = [points; [x, y]];
                %plot(x, y, 'r+')
            end
        end
    end
    %hold off;
    if size(points, 1) == 16
        court_offset = 80;
        fixedPoints = GetCorners(points);
        A = unique(fixedPoints(:,1:2),'rows');
        if size(A, 1) == 4
            person_x = width/2;
            person_y = height/2;
            person_width = 50;
            person_height = 50;
            peopleDetector.ClassificationThreshold = 2.0;
            peopleDetector.ScaleFactor = 1.25;
            % peopleDetector.MergeDetections = true;
            % peopleDetector.UseROI = true;
            % roi = [person_x person_y person_width person_height];
            [bboxes, scores] = peopleDetector(im(200:end, :, :));
            bboxes(:, 2) = bboxes(:, 2) + 200;
            if size(bboxes, 1) == 0
                continue;
            end
            I_people = insertObjectAnnotation(im, 'rectangle', ...
                                                bboxes, scores);
            %imshow(I_people), hold on;
            locations = GetPlayerLocations(bboxes);
            %plot(locations(:, 1), locations(:, 2), 'r+', 'MarkerSize', 30, 'LineWidth', 2);
            %hold off;
            %pause(0.01);
            top_left = [0, 0];
            bottom_left = [0, 390];
            bottom_right = [180, 390];
            top_right = [180, 0];
            movingPoints = [top_left; bottom_left; bottom_right; top_right];
            tform = estimateGeometricTransform(fixedPoints, ...
                                                movingPoints, 'projective');
            B = imwarp(im, tform, 'OutputView', ...
                                        imref2d([390 + court_offset, 180]));
            B2 = transformPointsForward(tform, locations);
            %imshow(B);
            
            playerLocations = [B2(1)+20, B2(2) + 80; playerLocations];
            X_pt = B2(1)+20;
            Y_pt = B2(2)+80;
            
            figure(1), plot(X_pt, Y_pt, 'r.', 'MarkerSize', 5, 'LineWidth', 1);
            pause(0.01);
        end
    end
    
    distance = GetDistances(playerLocations);
    timeElapsed = frameNumber / rate;
    frames = [frames; frameNumber];
    
    speed = GetAvgSpeed(distance, timeElapsed);
    if speed > max_speed
        max_speed = speed;
    end
    playerSpeeds = [playerSpeeds; speed];
    
    loc = size(playerSpeeds, 1);
    pos = size(frames, 1);
    if loc > 1
        deltaTime = frames(pos) - frames(pos - 1);
        deltaTime = deltaTime / rate;
        local_acc = GetAccelaration(playerSpeeds(loc - 1), playerSpeeds(loc), deltaTime);
    end
    if local_acc > acc
        acc = local_acc;
    end
    
    clc;
    fprintf('Approximate Distance Covered: %0.2f FT', distance);
    fprintf('\nApproximate Time Elapsed: %0.2f SECS', timeElapsed);
    fprintf('\nApproximate Speed: %0.2f KMPH', speed);
    fprintf('\nApproximate Maximum Speed: %0.2f KMPH', max_speed);
    fprintf('\nApproximate Acceleration: %0.2f KM/H^2\n', abs(local_acc));
    
end
hold off;
GenerateHeatmap(playerLocations);