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

pictureTimer = tic
first = true;
timeEstimate = Inf;
threshhold = 0.3;
numPictures = 0;
while(true)

    codeTimer = tic;
    picR = snapshot(camR);
    picL = snapshot(camL);

    r = calc(picR);
    l = calc(picL);
    if r(1) == 1 && l(1) == 1
        
        dt = toc(pictureTime);
        pictureTimer = tic;
        
        pos = coordinateConverter(r(2), r(3), l(2), l(3))
        
        %Pass to kalman filter
        if(first)
            estimate = kfilter(true, pos(1), pos(3), []);
            first = false;
        else
            estimate = kfilter(false, pos(1), pos(3), dt);
        end
        
        timeEsimate = estimate.time;
        lastTheta = estimate.theta;
        
        numPictures = numPictures + 1;
 
    end
    
    codeTimeElapsed = toc(codeTimer);
    timeEstimate = timeEstimate - codeTimeElapsed;
    
    if(timeEstimate < threshhold) %Can add a condition here like if numPictures > 4 or whatever to ensure its accurate
        tic
        projectedTime = trajectorymodel(lastTheta(1), lastTheta(4), lastTheta(2), lastTheta(5), false);
        projectedTime = projectedTime - toc(pictureTime);

                
        if(projectedTime < 0 || projectedTime == Inf)
            disp("Invalid Time Estimate");
        end
                
        triggerSolenoid(projectedTime);

        break;    
    end
end
