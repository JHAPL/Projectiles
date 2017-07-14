function f = setGlobal()
global initialXInterceptor initialZInterceptor initialVXInterceptor initialVZInterceptor;
initialXInterceptor = 0;
initialZInterceptor = 0;
initialVXInterceptor = -20 * sin(45);
initialVZInterceptor = 20 * cos(45);
end