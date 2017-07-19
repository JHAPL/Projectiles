function f = setGlobal()
global initialXThreat initialZThreat initialVXThreat initialVZThreat;
initialXThreat = -15;
initialZThreat = 0;
initialVXThreat = 5;
initialVZThreat = 15;

global initialXInterceptor initialZInterceptor initialVXInterceptor initialVZInterceptor;
initialXInterceptor = 0;
initialZInterceptor = 0;
initialVXInterceptor = -10 * sin(pi/4);
initialVZInterceptor = 10 * cos(pi/4);

%Process error matrix
global sigmaX sigmaZ Q;
sigmaX = 0.1; %When you change this change Q as well. 
sigmaZ = 0.1;
Q = 0.01 * diag(ones(6, 1));

global timeThreshhold;
timeThreshhold = 0.3;


end

%TODO Add initial threat positions too