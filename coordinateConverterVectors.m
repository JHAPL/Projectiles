function coor = coordinateConverterVectors(rx, ry, lx, ly)

%%% ============================== Inputs ============================= %%%
% rx - The right camera x position in pixels away from center
% ry - The right camera y position in pixels away from center
% lx - The left camera x position in pixels away from center
% ly - The left camera y position in pixels away from center
%%% ============================= Outputs ============================= %%%
% coordinates - [x,y,z] of the threat relative to the interceptor

d = .98; %distance between cameras

%camera angles
alphaz = 10 * pi/180;
alphax = 90 * pi/180;
beta = .1276 * pi/180;

%other angles
alphaL = alphax - lx * beta;
alphaR = alphax + rx * beta;

alphaUpL = alphaz + ly * beta;
alphaUpR = alphaz + ry * beta;

leftVector = [-cos(alphaUpL) * cos(alphaL), cos(alphaUpL) * sin(alphaL), sin(alphaUpL)];
rightVector = [-cos(alphaUpR) * cos(alphaR), -cos(alphaUpR) * sin(alphaR), sin(alphaUpR)];

pL = [0,-d/2,0];
pR = [0,d/2,0];
n = cross(leftVector,rightVector);
n1 = cross(leftVector,n);
n2 = cross(rightVector,n);
cL = pL + (dot((pR - pL), n2) / (dot(leftVector,n2))) * leftVector;
cR = pR + (dot((pL - pR), n1) / (dot(rightVector,n1))) * rightVector;

coor = (cL + cR)/2;
end
