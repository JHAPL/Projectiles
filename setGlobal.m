function f = setGlobal()
global initialXThreat initialZThreat initialVXThreat initialVZThreat;
initialXThreat = -25;
initialZThreat = 0;
initialVXThreat = 7.5;
initialVZThreat = 15;

global initialXInterceptor initialZInterceptor initialVXInterceptor initialVZInterceptor;
initialXInterceptor = 0;
initialZInterceptor = 0;
initialVXInterceptor = -20 * sin(45);
initialVZInterceptor = 20 * cos(45);

global sigmaX sigmaZ;
sigmaX = 0.5; %When you change this change Q as well. 
sigmaZ = 0.5;

global timeThreshhold;
timeThreshhold = 0.3;

end

%TODO Add initial threat positions too