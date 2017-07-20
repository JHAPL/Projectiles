function timeTillLaunch = trajectorymodel(startingX, startingZ, startingVX, startingVZ, makePlots)

%%% ============================== Inputs ============================= %%%
% time - The times at which to get the paths of the objects
% startingX - The initial X position of the threat (interceptor at 0,0)
% startingZ - The initial Z position of the threat (interceptor at 0,0)
% startingVX - The initial X velocity of the threat
% startingVZ - The initial Z velocity of the threat
% makePlots - A boolean (true if plots are to be displayed)
%%% ============================= Outputs ============================= %%%
% timeTillLaunch - The amount of time until launch from the measurement
% time. NOT accounting for process time. If no intersection, return
% infinity

%Time interval
timeStep = 0.01;
time = 0:timeStep:(5 - timeStep);

%Get paths
paths = getPaths(time, startingX, startingZ, startingVX, startingVZ);
YInterceptor = paths.interceptor;
YThreat = paths.threat;
if(makePlots)
    plot(YInterceptor(:,3), YInterceptor(:,4), 'b');
    hold on;
    plot(YThreat(:,3), YThreat(:,4), 'r');
end

%Calculate intersections
[intersectionX, intersectionY] = intersections(YInterceptor(:, 3), YInterceptor(:, 4), YThreat(:, 3), YThreat(:, 4));
if(isempty(intersectionX))
    timeTillLaunch = Inf;
    return;
end

intersectionX = intersectionX(length(intersectionX));
intersectionY = intersectionY(length(intersectionY));
%TODO Deal with when there is no intersection or when the only intersection
%is on the upswing

%Iterator through the paths
%Finds the index of the first x greater than the intersection point
%Finds the time at these points
iThreat = find(YThreat(:, 3) > intersectionX, 1);
%If there is no intersection, return infinity for time
if(iThreat == 1)
    timeTillLaunch = Inf;
    return;
end
xBefore = YThreat(iThreat - 1, 3);
xAfter = YThreat(iThreat, 3);
xDif = xAfter - xBefore;
xDifToIntersection = intersectionX - xBefore;
ratio = xDifToIntersection / xDif;
timeIntersectionThreat = time(iThreat) + ratio * timeStep;

%Depends on initial direction of interceptor
global initialVXInterceptor;
iInterceptor = find(sign(YInterceptor(:, 3)- intersectionX) == sign(initialVXInterceptor), 1);
if(iInterceptor == 1)
    timeTillLaunch = Inf;
    return;
end
xBefore = YInterceptor(iInterceptor - 1, 3);
xAfter = YInterceptor(iInterceptor, 3);
xDif = xAfter - xBefore;
xDifToIntersection = intersectionX - xBefore;
ratio = xDifToIntersection / xDif;
timeIntersectionInterceptor = time(iInterceptor) + ratio * timeStep;

%Find the time until the interceptor needs to be launched
timeTillLaunch = timeIntersectionThreat - timeIntersectionInterceptor;

%TODO Clean up plots and other stuff
%Plot everything
if(makePlots)
    plot(YInterceptor(1:iInterceptor,3), YInterceptor(1:iInterceptor,4), 'b');
    hold on;
    plot(YThreat(1:iThreat,3), YThreat(1:iThreat,4), 'r');
    plot(YInterceptor(iInterceptor: length(YInterceptor),3), YInterceptor(iInterceptor: length(YInterceptor),4), ':b');
    plot(YInterceptor(iInterceptor: length(YInterceptor),3), YInterceptor(iInterceptor: length(YInterceptor),4), ':b');
    plot(YThreat(iThreat:length(YThreat),3), YThreat(iThreat:length(YThreat),4), ':r');
    plot(intersectionX, intersectionY, '-*k');
    
    %Set plot limits
    xlim([-40, 0]);
    ylim([.1, 30]);
    title('Kickball ICBM VS. Raquetball SAM');
    xlabel('X Position in Meters');
    ylabel('Y Position in Meters');
    legend('Interceptor', 'Target');
end
