1%%
clear
clc
%%
q = input('what camera (1 or 2) ');
camera = webcam(q);
camera.Resolution = '352x288';
preview(camera)
% a = input('face plane to ball ');
% b = input('perpendicular plane to ball ');
% c = input('height of the center of the ball ');
a = 2.5;
b = .5;
 c = .19;
angle1 = atan(a/b);
angle2 = atan(c/(sqrt(a^2 + b^2)));
while(true)
    pic = snapshot(camera);
    centerPoint = calc(pic);
    if (centerPoint(1) == 1)
        x = centerPoint(2);
        y = centerPoint(3);
        dpp = (.1276 * pi)/180;
        if(q == 2)
            x = -1 * x;
        end
        tx = x * dpp;
        ty = y * dpp;
        w = ((angle1 + tx)*180)/pi;
        v = ((angle2 - ty)*180)/pi;
        cameraangles = [w v];
        disp(cameraangles);
    end
end

%%
function centerPoint = calc(ball)
    
    red = double(ball(:,:,1)); green = double(ball(:,:,2)); blue = double(ball(:,:,3));
    rtg = 1.9; 
    rtb = 1.9;
    darktresh = 20;
    out = red./(green)>rtg & red./(blue)>rtb & red>darktresh;
    
    out = imfill(out,'holes');
    out = bwmorph(out,'dilate',3);
    out = imfill(out,'holes');
    [B,L] = bwboundaries(out,'noholes');
    
    stats = regionprops(L,'Area','centroid');
    threshold = .65;  %go back to
    foundOne = false;
    largestArea = 0;
    center = zeros(2);
    for k = 1:length(B)
        Boundary = B{k};
        delta_sq = diff(Boundary).^2;
        perimeter = sum(sqrt(sum(delta_sq,2)));
        area = stats(k).Area;
        metric = 4*pi*area/perimeter^2;
        metric_string = sprintf('%2.2f',metric);
        if metric > threshold
            foundOne = true;
            centroid = stats(k).Centroid;
            mapcenter = [-176,-144];
            if(area > largestArea)
                largestArea = area;
                center = centroid + mapcenter;
                center(2) = -1 * center(2);
            end            
        end
    end
     centerPoint = [foundOne, center(1), center(2)];
end