function f = setGlobal()

global initialXThreat initialZThreat initialVXThreat initialVZThreat;
initialXThreat = -20;
initialZThreat = 0;
initialVXThreat = 15 * cos(pi / 3);
initialVZThreat = 15 * sin(pi / 3);

global initialXInterceptor initialZInterceptor initialVXInterceptor initialVZInterceptor;
initialXInterceptor = 0;
initialZInterceptor = 0;
initialVXInterceptor = -15 * sin(pi/4);
initialVZInterceptor = 15 * cos(pi/4);

%Process error matrix
global sigmaX sigmaZ a_sigma Sw;
sigmaX = 0.1;
sigmaZ = 0.1;
a_sigma = 0.5;
Sw = a_sigma ^ 2 / 25;

%If estimated time until launch is less than this, stop camera measurments
%and commence better estimates and launch
global timeThreshhold;
timeThreshhold = 0.2;

noTimeThreshhold = false;
if(noTimeThreshhold)
    timeThreshhold = -Inf;
end


%Define parameters for threat structure
global threatParams;
threatParams.mass = 1.134;
threatParams.area = 0.05067;
threatParams.drag = 0.2;

%Define parameters for interceptor initial conditions and structure
global interceptorParams interceptorIC;
interceptorParams.mass = 0.0427;
interceptorParams.area = 0.0025652;
interceptorParams.drag = 0.2;
interceptorIC = [initialVXInterceptor,initialVZInterceptor,initialXInterceptor,initialZInterceptor];

%Physical constants
global gravity density
gravity = 9.8; %m/s^2
density = 1.225; %of the air in kg/m^3

global interceptorTime;
%Time interval
pathTimeStep = 0.01;
interceptorTime = 0:pathTimeStep:(5 - pathTimeStep);
global tInterceptor YInterceptor;
[tInterceptor, YInterceptor] = ode45(@(t,Y) trajectory(t,Y,interceptorParams), interceptorTime, interceptorIC);



end

