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


end

%TODO Add initial threat positions too