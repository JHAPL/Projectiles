%% test
clear
clc
%%
% assigining the camera a value
camR = webcam(2);
camL = webcam(1);
% lowering camera resolution
camR.Resolution = '352x288';
camL.Resolution = '352x288';

setup();
global timeThreshhold;
testingKalman = false;

lastPicture = tic;
first = true;
while(true)
    calculationTime = tic;
    picR = snapshot(camR);
    picL = snapshot(camL);
    r = calc(picR);
    l = calc(picL);
    if r(1) == 1 && l(1) == 1
        pos = coordinateConverter(r(2), r(3), l(2), l(3))
        
        
        if(testingKalman)
            dt = toc(lastPicture);
      
            if(first)
                estimate = kfilter(true, pos(1), pos(3), []);
                first = false;
            else
                estimate = kfilter(false, pos(1), pos(3), dt);
            end
            
            if (estimate.time < timeThreshhold)
                projectedTime = trajectorymodel(theta(1), theta(4), theta(2), theta(5),plots && ~debugging);
                if(projectedTime < 0 || projectedTime == Inf)
                    disp("Invalid Time Estimate");
                    break;
                end
                triggerSolenoid(projectedTime - toc(calculationTime));
                break;
            end
            lastPicture = tic;
        end
    end
end
