function f = setGlobal()
global initialXThreat initialZThreat initialVXThreat initialVZThreat;
initialXThreat = -15;
initialZThreat = 0;
initialVXThreat = 5;
initialVZThreat = 15;

global initialXInterceptor initialZInterceptor initialVXInterceptor initialVZInterceptor;
initialXInterceptor = 0;
initialZInterceptor = 0;
initialVXInterceptor = -15 * sin(pi/4);
initialVZInterceptor = 15 * cos(pi/4);

%Process error matrix
global sigmaX sigmaZ Q;
sigmaX = 0.4; %When you change this change Q as well. Actually not sure of this
sigmaZ = 0.4;
Q =  .01 * diag(ones(6, 1)); %.01 a good value for 0.5/0.4

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


end

