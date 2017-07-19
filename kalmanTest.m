setGlobal();
global initialXThreat initialZThreat initialVXThreat initialVZThreat;
global sigmaX sigmaZ;
global timeThreshhold;
count = 0;
%for a = 1:1000
    
    %Change in time (represents ideal frames/second and update rate)
    dt = 1/25;
    %Total time
    t = 0:dt:5;
    
    
    %TODO: Make folders
    %TODO: ESTIMATE DRAG COEEFICIANTS
    %TODO: Remove redundant kalman filter code
    %TODO: Remove half of the path generation code (do it once)
    
    
    %find the ideal paths of the target and interceptor (only target is used)
    path = getPaths(t, initialXThreat, initialZThreat, initialVXThreat, initialVZThreat);
    threat = path.threat;
    threat(1,:) = [];
    t(:,1) = [];
    
    kfilter(true, initialXThreat,initialZThreat,0);
    
    for i = 1:length(t)
        x = threat(i,3)' + randn(1) * sigmaX;
        z = threat(i,4)' + randn(1) * sigmaZ;
        estimate = kfilter(false,x,z,dt);
        time = estimate.time;
        theta = estimate.theta;
        
        
        %Its velocity thats the problem
        if time < timeThreshhold
            
            projectedTime = trajectorymodel(theta(1), theta(4), theta(2), theta(5),false);
            if projectedTime ~= Inf
                %actualTime = trajectorymodel(threat(i,3), threat(i,4), threat(i,1), threat(i,2), false);
                % projectedTime = actualTime;
                
                %Find the paramaters of the threat when the interceptor is
                %projected to launch
                lastKnownI = fix(projectedTime / dt) + i;
                lastKnownTime = fix(projectedTime / dt) * dt;
                tInterval = 0:0.001:projectedTime-lastKnownTime;
                if length(tInterval) ~= 1
                    paths = getPaths(tInterval, threat(lastKnownI,3), threat(lastKnownI,4), threat(lastKnownI,1), threat(lastKnownI,2));
                    launchDetails = paths.threat(end, :);
                else
                    launchDetails = threat(lastKnownI,:);
                end
                
                %Check if they would actually intersect
                tInterval = 0:0.001:10;
                paths = getPaths(tInterval, launchDetails(3), launchDetails(4), launchDetails(1), launchDetails(2));
                minDistance = Inf;
                for j = 1:length(tInterval)
                    distance = sqrt((paths.threat(j,3)-paths.interceptor(j,3))^2 + ...
                        (paths.threat(j,4)-paths.interceptor(j,4))^2);
                    if(distance < minDistance)
                        minDistance = distance;
                    end
                end
                if(minDistance < .13)
                    count = count + 1;
                end
            end
            
           % count / a
            break
            
        end
        
    end
%end