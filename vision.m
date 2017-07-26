%% test
clear
clc
%%
% assigining the camera a value
camR = webcam(2);
camL = webcam(1);
% lowering camera resolution
camR.Resolution = '352x288';
camL.Resolution = '352x288';

q = 0;
while(q <= 100)
    picR = snapshot(camR);
    picL = snapshot(camL);
    r = calc(picR);
    l = calc(picL);
    q = q + 1;
    if r(1) == 1 && l(1) == 1
       coordinateConverter(r(2), r(3), l(2), l(3))
    end
end
%%
function centerPoint = calc(ball)
    
    red = double(ball(:,:,1)); green = double(ball(:,:,2)); blue = double(ball(:,:,3));
    rtg = 2.0; 
    rtb = 2.0;
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
%%
