clear;
clc;
setup();


%angles in radians
thetaX=44.9152 * pi / 180;
thetaY=36.7488 * pi /180;

%angle of camera tilted up and to sides.. RADIANS
%NOTE: variables to change
cameraAngleUp = pi / 10;
cameraAngleInward = pi / 180 * 20; 

%NOTE: test different numbers (to change), in meters
disOffGround= 0.25;
camX = 2;
yOffset = 1.5;
fovLineLength=23;

%dimensions of camera
height=.1129;
width=.1158;

global initialXThreat initialZThreat initialVXThreat initialVZThreat;
global interceptorTime;


paths = getPaths(interceptorTime, initialXThreat, initialZThreat, initialVXThreat, initialVZThreat);
YInterceptor = paths.interceptor;
YThreat = paths.threat;

%Create an array for the interceptor and threat X positions and Y positions
interceptorPath = [YInterceptor(:,3), YInterceptor(:,4)];
threatPath = [YThreat(:,3), YThreat(:,4)];

%plot the target and interceptor
plot3(YInterceptor(:,3), zeros(4,length(interceptorTime)), YInterceptor(:,4), 'LineWidth', 4); grid on
hold on
plot3(YThreat(:,3), zeros(4,length(interceptorTime)), YThreat(:,4), 'LineWidth', 4); grid on

xlim([-30, 10]);
ylim([-15, 15]);
zlim([0, 15]);


angleUp = cameraAngleUp + thetaY / 2;
angleDown = cameraAngleUp - thetaY / 2;

initialPointR = [camX, yOffset, disOffGround + height / 2];
topLeftR = fovLineLength * [-cos(angleUp) * cos(thetaX / 2 - cameraAngleInward), cos(angleUp) * sin(thetaX / 2 - cameraAngleInward), sin(angleUp)] + initialPointR;  
topRightR = fovLineLength * [-cos(angleUp) * cos(thetaX / 2 + cameraAngleInward), -cos(angleUp) * sin(thetaX / 2 + cameraAngleInward), sin(angleUp)]  + initialPointR;  
bottomLeftR = fovLineLength * [-cos(angleDown) * cos(thetaX / 2 - cameraAngleInward), cos(angleDown) * sin(thetaX / 2 - cameraAngleInward), sin(angleDown)]  + initialPointR;  
bottomRightR = fovLineLength * [-cos(angleDown) * cos(thetaX / 2 + cameraAngleInward), -cos(angleDown) * sin(thetaX / 2 + cameraAngleInward), sin(angleDown)]  + initialPointR;  

pointsR = [initialPointR; topLeftR; topRightR; bottomLeftR; bottomRightR];
fill3(pointsR(1:3, 1), pointsR(1:3, 2), pointsR(1:3, 3), 0.5);
hold on
fill3(pointsR([1,2,4], 1), pointsR([1,2,4], 2), pointsR([1,2,4], 3), 0.5);
fill3(pointsR([1,3,5], 1), pointsR([1,3,5], 2), pointsR([1,3,5], 3), 0.5);
fill3(pointsR([1,4,5], 1), pointsR([1,4,5], 2), pointsR([1,4,5], 3), 0.5);
fill3(pointsR([2,3,5,4], 1), pointsR([2,3,5,4], 2), pointsR([2,3,5,4], 3), 0.5);
alpha(0.2)


initialPointL = [camX, -yOffset, disOffGround + height / 2];
topLeftL = fovLineLength * [-cos(angleUp) * cos(thetaX / 2 + cameraAngleInward), cos(angleUp) * sin(thetaX / 2 + cameraAngleInward), sin(angleUp)] + initialPointL;  
topRightL = fovLineLength * [-cos(angleUp) * cos(thetaX / 2 - cameraAngleInward), -cos(angleUp) * sin(thetaX / 2 - cameraAngleInward), sin(angleUp)]  + initialPointL;  
bottomLeftL = fovLineLength * [-cos(angleDown) * cos(thetaX / 2 + cameraAngleInward), cos(angleDown) * sin(thetaX / 2 + cameraAngleInward), sin(angleDown)]  + initialPointL;  
bottomRightL = fovLineLength * [-cos(angleDown) * cos(thetaX / 2 - cameraAngleInward), -cos(angleDown) * sin(thetaX / 2 - cameraAngleInward), sin(angleDown)]  + initialPointL;  

pointsL = [initialPointL; topLeftL; topRightL; bottomLeftL; bottomRightL];
fill3(pointsL(1:3, 1), pointsL(1:3, 2), pointsL(1:3, 3), 0.5);
fill3(pointsL([1,2,4], 1), pointsL([1,2,4], 2), pointsL([1,2,4], 3), 0.5);
fill3(pointsL([1,3,5], 1), pointsL([1,3,5], 2), pointsL([1,3,5], 3), 0.5);
fill3(pointsL([1,4,5], 1), pointsL([1,4,5], 2), pointsL([1,4,5], 3), 0.5);
fill3(pointsL([2,3,5,4], 1), pointsL([2,3,5,4], 2), pointsL([2,3,5,4], 3), 0.5);
alpha(0.2)

% plot3([camX, (topLeftL(1) + topRightL(1)) / 2], [0, 0], [disOffGround, topLeftL(3)]);
% intersections([camX, (topLeftL(1) + topRightL(1)) / 2], [disOffGround, topLeftL(3)], threatPath(:, 1), threatPath(:, 2))
% xMin = -20;
% disp(xMax - xMin)

%text(0,10,10, char(strcat('Angle Up: ', num2str(cameraAngleUp / pi * 180), " degrees, Angle In: ", num2str(cameraAngleInward / pi * 180), ' degrees')));
