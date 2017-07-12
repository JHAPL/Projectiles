function coor = coordinateConverter(rx, ry, lx, ly)

%%% ============================== Inputs ============================= %%%
% rx - The right camera x position in pixels away from center
% ry - The right camera y position in pixels away from center
% lx - The left camera x position in pixels away from center
% ly - The left camera y position in pixels away from center
%%% ============================= Outputs ============================= %%%
% coordinates - [x,y,z] of the threat relative to the interceptor 

    d = 2; %distance between cameras
    
    %camera angles
    alphaz = 45 * pi/180;
    alphax = 45 * pi/180;
    beta = .1276 * pi/180;

    %other angles
    alphal = alphax - lx * beta;
    alphar = alphax + rx * beta;

    %equations
    m = d*sin(alphar)/sin(pi - alphal - alphar);
    n = sqrt(m^2 + d^2 / 4 - m*d*cos(alphal));
    %theta = acos(m^2 - ((d^2)/4) - n^2 + n*d) - pi/2;
    theta = asin((m * sin(alphal))/(n)) + pi/2;
    
    %final equations
    y = n*sin(theta);
    x = n*cos(theta);
    zl = abs( sqrt(x^2 + ((d/2) + y)^2) * tan(alphaz + ly * beta));
    zr = abs( sqrt(x^2 + ((d/2) - y)^2) * tan(alphaz + ry * beta));
    z = (zl + zr)/2;
    
    coor = [x,y,z];

end
