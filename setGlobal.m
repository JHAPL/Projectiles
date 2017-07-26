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
global sigmaX sigmaZ Q;
sigmaX = .1; %When you change this change Q as well. Actually not sure of this
sigmaZ = .1;
Q =  .001 * diag(ones(6, 1)); %.01 a good value for 0.5/0.4
%Q =  100000 * (ones(6, 6)); %.01 a good value for 0.5/0.4

%If estimated time until launch is less than this, stop camera measurments
%and commence better estimates and launch
global timeThreshhold;
timeThreshhold = 0.3;



%Define parameters for threat structure
global threatParams;
threatParams.mass = 1.134;
threatParams.area = 0.05067;
threatParams.drag = 0.47;

%Define parameters for interceptor initial conditions and structure
global interceptorParams interceptorIC;
interceptorParams.mass = 0.0427;
interceptorParams.area = 0.0025652;
interceptorParams.drag = 0.47;
interceptorIC = [initialVXInterceptor,initialVZInterceptor,initialXInterceptor,initialZInterceptor];

%Physical constants
global gravity density
gravity = 9.8; %m/s^2
density = 1.225; %of the air in kg/m^3

end

