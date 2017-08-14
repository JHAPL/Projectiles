%% test
clear
clc
setup();
%%
% assigining the camera a value
camR = webcam(1);
camL = webcam(2);
% lowering camera resolution
camR.Resolution = '352x288';
camL.Resolution = '352x288';

setup();
global timeThreshhold;

tic
first = true;
while(true)

    picR = snapshot(camR);
    picL = snapshot(camL);
    dt = toc;
    tic;
    r = calc(picR);
    l = calc(picL);
    if r(1) == 1 && l(1) == 1
        pos = coordinateConverter(r(2), r(3), l(2), l(3))
        
        %Pass to kalman filter
        if(first)
            estimate = kfilter(true, pos(1), pos(3), []);
            first = false;
        else
            estimate = kfilter(false, pos(1), pos(3), dt);
        end
        
        %If ball is moving down, stop the kalman filter and estimate landing point of ball
        endLoop = false;
        theta = estimate.theta;
        if(theta(5) < 0)
        
            %Time interval, next 5 seconds
            timeStep = 0.01;
            time = 0:timeStep:(5 - timeStep);
            paths = getPaths(time, theta(1), theta(3), theta(2), theta(5));
            threatPath = paths.threat;
            
            %Finds first predicted place where z coordinate is less than 0, prints out the x coordinate there, assuming camera is at 0
            %And that the threat launches negative to positive
            for i = 1:length(threatPath)
                if(threatPath(4) < 0) 
                    disp(threatPath(3));
                    break;
                end
            end
            
            break;
 
    end
end
