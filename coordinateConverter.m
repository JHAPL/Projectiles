function  coordinates = coordinateConverter(rx, ry, lx, ly)

%%% ============================== Inputs ============================= %%%
% rx - The right camera x position in pixels away from center
% ry - The right camera y position in pixels away from center
% lx - The left camera x position in pixels away from center
% ly - The left camera y position in pixels away from center
%%% ============================= Outputs ============================= %%%
% coordinates - [x,y,z] of the threat relative to the interceptor 

    d = 5; %distance between cameras
    
    %camera angles
    alphaz = 10 * pi/180;
    alphax = 10 * pi/180;
    beta = .1276 * pi/180;

    %other angles
    alphal = alphax - lx * beta;
    alphar = alphax + rx * beta;

    %equations
    m = d*sin(alphar)/sin(pi - alphal - alphar);
    n = sqrt(m^2 + d^2 / 4 - m*d*cos(alphal));
    theta = asin(m*sin(alphal)/n) - pi/2;

    %final equations
    y = n*sin(theta);
    x = - abs( n*cos(theta));
    zl = abs( x*tan(alphaz + ly * beta));
    zr = abs( x*tan(alphaz + ry * beta));
    z = (zl + zr)/2;
    coordinates = [x,y,z];

end
