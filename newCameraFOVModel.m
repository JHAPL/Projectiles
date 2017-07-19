clear;
clc;
tic;


%angles in radians
thetaX=44.9152 * pi / 180;
thetaY=36.7488 * pi /180;

%angle of camera tilted up and to sides.. RADIANS
%NOTE: variables to change
cameraAngleUp = 10*pi/180;
cameraAngleToSide = 0; 

%2 indicates camera 2
cameraAngleUp2 = 10*pi/180;
cameraAngleToSide2 = 0; 

%NOTE: test different numbers (to change), in meters
disOffGround=3;
cam1PosX=0;
cam2PosX=0;
cam1PosY=1;
cam2PosY=-1;
fovLineLength=20;

%dimensions of camera
height=.1129;
width=.1158;

global initialXThreat initialZThreat initialVXThreat initialVZThreat;


%Get paths
time = 0:.01:9.99;
paths = getPaths(time, initialXThreat, initialZThreat, initialVXThreat, initialVZThreat);
YInterceptor = paths.interceptor;
YThreat = paths.threat;

%Create an array for the interceptor and threat X positions and Y positions
interceptorPath = [YInterceptor(:,3), YInterceptor(:,4)];
threatPath = [YThreat(:,3), YThreat(:,4)];

toc;

%plot the target and interceptor
plot3(YInterceptor(:,3), zeros(4,1000), YInterceptor(:,4)); grid on

hold on

plot3(YThreat(:,3), zeros(4,1000), YThreat(:,4)); grid on

%camera 1 location, NOTE: a variable to change
plot3([cam1PosX,cam1PosX,cam1PosX,cam1PosX,cam1PosX], [cam1PosY-width/2,cam1PosY-width/2,cam1PosY+width/2,cam1PosY+width/2,cam1PosY-width/2], [disOffGround,disOffGround+height,disOffGround+height,disOffGround,disOffGround]);

%camera 2 location, NOTE: a variable to change
plot3([cam2PosX,cam2PosX,cam2PosX,cam2PosX,cam2PosX], [cam2PosY-width/2,cam2PosY-width/2,cam2PosY+width/2,cam2PosY+width/2,cam2PosY-width/2], [disOffGround,disOffGround+height,disOffGround+height,disOffGround,disOffGround]);

%camera 1 bore's sight line
boreVecX = zeros (fovLineLength,1);
boreVecY = zeros (fovLineLength,1);
boreVecZ = zeros (fovLineLength,1);

%camera 2
boreVecX2 = zeros (fovLineLength,1);
boreVecY2 = zeros (fovLineLength,1);
boreVecZ2 = zeros (fovLineLength,1);

%NOTE: will need to change this if cameras have different X positions
count = cam1PosX;
countY=0;
pos2 = fovLineLength;
pos = 1;

while pos2>0
    
    boreVecX(pos) = count ;
    boreVecY(pos) = countY * tan(cameraAngleToSide)+cam1PosY;
    boreVecZ(pos2) = count * tan(cameraAngleUp)+disOffGround+height/2;
    
    %camera 2
    boreVecX2(pos) = count;
    boreVecY2(pos) = countY * tan(cameraAngleToSide2)+cam2PosY;
    boreVecZ2(pos2) = count * tan(cameraAngleUp2)+disOffGround+height/2;
    
    pos = pos+1;
    pos2 = pos2-1;
    
    count = count-1;
    countY=countY+1;
    
end

%bores sight line for camera 1 and 2
plot3(boreVecX, boreVecY, boreVecZ);

plot3(boreVecX2, boreVecY2, boreVecZ2);

%outer lines for cameras, NOTE: use boreVecY for y
upperLeftY = zeros(fovLineLength, 1);
upperLeftZ = zeros(fovLineLength, 1);
upperRightY = zeros(fovLineLength, 1);
upperRightZ = zeros(fovLineLength, 1);
lowerLeftY = zeros(fovLineLength, 1);
lowerLeftZ = zeros(fovLineLength, 1);
lowerRightY = zeros(fovLineLength, 1);
lowerRightZ = zeros(fovLineLength, 1);

%camera 2
upperLeftY2 = zeros(fovLineLength, 1);
upperLeftZ2 = zeros(fovLineLength, 1);
upperRightY2 = zeros(fovLineLength, 1);
upperRightZ2 = zeros(fovLineLength, 1);
lowerLeftY2 = zeros(fovLineLength, 1);
lowerLeftZ2 = zeros(fovLineLength, 1);
lowerRightY2 = zeros(fovLineLength, 1);
lowerRightZ2 = zeros(fovLineLength, 1);

count=0;
pos2=1;

%NOTE: these may need to take camera position into account
while count<fovLineLength
    
    lowerLeftY(pos2) = boreVecY(pos2)+ count * tan (thetaX/2) + width/2 ;
    lowerLeftZ(pos2) = boreVecZ(pos2) - count * tan(thetaY/2) - height/2;
    
    upperLeftY(pos2) = boreVecY(pos2)+ count * tan (thetaX/2) + width/2;
    upperLeftZ(pos2) = boreVecZ(pos2) + count * tan(thetaY/2) + height/2;
    
    upperRightY(pos2) = boreVecY(pos2)- count * tan (thetaX/2) - width/2 ;
    upperRightZ(pos2) = boreVecZ(pos2) + count * tan(thetaY/2) + height/2;
    
    lowerRightY(pos2) = boreVecY(pos2)- count * tan (thetaX/2) - width/2;
    lowerRightZ(pos2) = boreVecZ(pos2) - count * tan(thetaY/2) - height/2;
    
    %camera 2
    lowerLeftY2(pos2) = boreVecY2(pos2)+ count * tan (thetaX/2) + width/2;
    lowerLeftZ2(pos2) = boreVecZ2(pos2) - count * tan(thetaY/2) - height/2;
    
    upperLeftY2(pos2) = boreVecY2(pos2)+ count * tan (thetaX/2) + width/2;
    upperLeftZ2(pos2) = boreVecZ2(pos2) + count * tan(thetaY/2) + height/2;
    
    upperRightY2(pos2) = boreVecY2(pos2)- count * tan (thetaX/2) -width/2;
    upperRightZ2(pos2) = boreVecZ2(pos2) + count * tan(thetaY/2) + height/2;
    
    lowerRightY2(pos2) = boreVecY2(pos2)- count * tan (thetaX/2) - width/2;
    lowerRightZ2(pos2) = boreVecZ2(pos2) - count * tan(thetaY/2) - height/2;   
    
    pos2=pos2+1;
    
    count= count+1;
    
end

plot3(boreVecX,lowerLeftY , lowerLeftZ,'--');
plot3(boreVecX,upperLeftY , upperLeftZ,'--');
plot3(boreVecX,lowerRightY , lowerRightZ,'--');
plot3(boreVecX,upperRightY , upperRightZ,'--');

plot3(boreVecX,lowerLeftY2 , lowerLeftZ2,'--');
plot3(boreVecX,upperLeftY2 , upperLeftZ2,'--');
plot3(boreVecX,lowerRightY2 , lowerRightZ2,'--');
plot3(boreVecX,upperRightY2, upperRightZ2,'--');

%create funnels
plane1X=[cam1PosX,cam1PosX, cam1PosX-fovLineLength,cam1PosX-fovLineLength,cam1PosX];
plane1Y=[cam1PosY+width/2,cam1PosY+width/2, upperLeftY(fovLineLength),lowerLeftY(fovLineLength),cam1PosY+width/2];
plane1Z=[disOffGround, disOffGround+height, upperLeftZ(fovLineLength),lowerLeftZ(fovLineLength),disOffGround];

colors=[.5,.5,.5,.5,.5];

fill3(plane1X,plane1Y,plane1Z,colors);
alpha(.5);

plane2Y=[cam1PosY+width/2,cam1PosY-width/2,upperRightY(fovLineLength),upperLeftY(fovLineLength),cam1PosY+width/2];
plane2Z=[disOffGround+height,disOffGround+height,upperRightZ(fovLineLength),upperLeftZ(fovLineLength) ,disOffGround+height];

fill3(plane1X,plane2Y,plane2Z,colors);
alpha(.5);

plane3Y=[cam1PosY-width/2,cam1PosY-width/2,upperRightY(fovLineLength) ,lowerRightY(fovLineLength),cam1PosY-width/2];
plane3Z=[disOffGround,disOffGround+height,upperRightZ(fovLineLength),lowerRightZ(fovLineLength),disOffGround];

fill3(plane1X,plane3Y,plane3Z, colors);
alpha(.5);

plane4Y=[cam1PosY+width/2,cam1PosY-width/2,lowerRightY(fovLineLength),lowerLeftY(fovLineLength),cam1PosY+width/2];
plane4Z=[disOffGround,disOffGround,lowerRightZ(fovLineLength),lowerLeftZ(fovLineLength),disOffGround];

fill3(plane1X,plane4Y,plane4Z,colors);
alpha(.5);

%camera2 funnels
plane1X=[cam2PosX,cam2PosX, cam2PosX-fovLineLength,cam2PosX-fovLineLength,cam2PosX];
plane1Y=[cam2PosY+width/2,cam2PosY+width/2, upperLeftY2(fovLineLength),lowerLeftY2(fovLineLength),cam2PosY+width/2];
plane1Z=[disOffGround, disOffGround+height, upperLeftZ2(fovLineLength),lowerLeftZ2(fovLineLength),disOffGround];

colors=[.5,.5,.5,.5,.5];

fill3(plane1X,plane1Y,plane1Z,colors);
alpha(.5);

plane2Y=[cam2PosY+width/2,cam2PosY-width/2,upperRightY2(fovLineLength),upperLeftY2(fovLineLength),cam2PosY+width/2];
plane2Z=[disOffGround+height,disOffGround+height,upperRightZ2(fovLineLength),upperLeftZ2(fovLineLength) ,disOffGround+height];

fill3(plane1X,plane2Y,plane2Z,colors);
alpha(.5);

plane3Y=[cam2PosY-width/2,cam2PosY-width/2,upperRightY2(fovLineLength) ,lowerRightY2(fovLineLength),cam2PosY-width/2];
plane3Z=[disOffGround,disOffGround+height,upperRightZ2(fovLineLength),lowerRightZ2(fovLineLength),disOffGround];

fill3(plane1X,plane3Y,plane3Z, colors);
alpha(.5);

plane4Y=[cam2PosY+width/2,cam2PosY-width/2,lowerRightY2(fovLineLength),lowerLeftY2(fovLineLength),cam2PosY+width/2];
plane4Z=[disOffGround,disOffGround,lowerRightZ2(fovLineLength),lowerLeftZ2(fovLineLength),disOffGround];

fill3(plane1X,plane4Y,plane4Z,colors);
alpha(.5);

%plot layout
xlim([-30, 70]);
ylim([-20, 20]);
zlim([0, 30]); 
xlabel('X axis');
ylabel('Y axis');
zlabel('Height in meters');
title('Camera FOV Model');