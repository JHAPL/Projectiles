%% test
%Make sure to set all parameters
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

pictureTimer = tic;
first = true;
timeEstimate = Inf;
threshhold = 0.3;
numPictures = 0;
minPicturesToLaunch = 4;
camXPosition = 0;


measurementsXs = zeros(1000);
measurementsZs = zeros(1000);
filteredXs = zeros(1000);
filteredZs = zeros(1000);

while(true)

    codeTimer = tic;
    picR = snapshot(camR);
    picL = snapshot(camL);

    r = calc(picR);
    l = calc(picL);
    if r(1) == 1 && l(1) == 1
        numPictures = numPictures + 1;
        
        dt = toc(pictureTime); %Time since the last successful picture
        pictureTimer = tic;
        
        pos = coordinateConverter(r(2), r(3), l(2), l(3));
        pos(1) = pos(1) - cameraXPosition; %Important line
        measurementsXs(numPictures) = pos(1);
        measurementsZs(numPictures) = pos(3);

        
        %Pass to kalman filter
        if(first)
            estimate = kfilter(true, pos(1), pos(3), []);
            first = false;
        else
            estimate = kfilter(false, pos(1), pos(3), dt);
        end
        
        timeEsimate = estimate.time;
        lastTheta = estimate.theta;
        filteredXs(numPictures) = lastTheta(1);
        filteredZs(numPictures) = lastTheta(4);
 
    end
    
    codeTimeElapsed = toc(codeTimer);
    timeEstimate = timeEstimate - codeTimeElapsed;
    
    
    if(timeEstimate < threshhold && numPictures >= minPicturesToLaunch)
        projectedTime = trajectorymodel(lastTheta(1), lastTheta(4), lastTheta(2), lastTheta(5), false);
        projectedTime = projectedTime - toc(pictureTime);

                
        if(projectedTime < 0 || projectedTime == Inf)
            disp("Invalid Time Estimate");
            break;
        end
                
        triggerSolenoid(projectedTime);

        break;    
    end
end
